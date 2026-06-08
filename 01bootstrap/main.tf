# ======================================================================
# Bootstrap Stage — main.tf
# ======================================================================
#
# Purpose: Create the foundational GCP resources required by all later
# stages: the Terraform state bucket, per-stage service accounts, and
# Workload Identity Federation for GitHub Actions CI/CD.
#
# This is run ONCE manually from your machine. After this completes,
# every other stage uses the resources created here.
#
# ======================================================================

# ----------------------------------------------------------------------
# PROJECT 1: bootstrap-infra-state
# ----------------------------------------------------------------------
# Holds the GCS bucket for Terraform remote state and the per-stage
# service accounts that Terraform will impersonate in each stage.

resource "google_project" "state_project" {
  name            = "Bootstrap Infrastructure - State"
  project_id      = "bootstrap-infra-state"
  org_id          = var.organization_id
  billing_account = var.billing_account_id
  labels = {
    stage      = "bootstrap"
    managed-by = "terraform"
    purpose    = "terraform-state"
  }
}

# Enable required APIs on the state project
resource "google_project_service" "state_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudbilling.googleapis.com",
  ])

  project = google_project.state_project.project_id
  service = each.key

  # Don't disable APIs when resources are removed
  disable_on_destroy = false
}

# ----------------------------------------------------------------------
# GCS BUCKET: Terraform Remote State
# ----------------------------------------------------------------------
# Stores the .tfstate files for ALL stages. Each stage gets its own
# prefix (e.g. "terraform/organization", "terraform/networks").
#
# Features:
#   - Object versioning: lets you recover previous state files
#   - Uniform bucket-level access: no per-object ACLs (simpler)
#   - Lifecycle rule: keeps last 3 versions, deletes older ones

resource "google_storage_bucket" "terraform_state" {
  name          = var.state_bucket_name
  project       = google_project.state_project.project_id
  location      = var.region
  storage_class = "STANDARD"

  # Prevent accidental deletion of the bucket
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      # Keep only the 3 most recent versions of each state file
      num_newer_versions = 3
    }
  }

  labels = {
    stage      = "bootstrap"
    managed-by = "terraform"
    purpose    = "terraform-state"
  }
}

# ----------------------------------------------------------------------
# SERVICE ACCOUNTS: One Per Stage
# ----------------------------------------------------------------------
# Each downstream stage gets its own service account with only the
# permissions it needs (least privilege). Terraform impersonates these
# SAs via workload identity federation.
#
# Naming:    terraform-<stage-name>
# Purpose:   <stage-name> stage operations
# IAM:       Granted at the folder or project level where it operates

locals {
  stages = {
    "terraform-org"              = "Organization stage - manages folders, IAM, org policies"
    "terraform-networks"         = "Networks stage - manages VPC, subnets, NAT, firewall"
    "terraform-service-projects" = "Service Projects stage - manages project creation"
  }
}

resource "google_service_account" "stage_sa" {
  for_each = local.stages

  account_id   = each.key
  display_name = each.value
  project      = google_project.state_project.project_id
}

# Grant each service account the ability to impersonate itself
# (this is needed for WIF-based authentication)
resource "google_service_account_iam_member" "sa_self_impersonation" {
  for_each = google_service_account.stage_sa

  service_account_id = each.value.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${each.value.email}"
}

# ----------------------------------------------------------------------
# PROJECT 2: bootstrap-cicd
# ----------------------------------------------------------------------
# Holds the Workload Identity Federation resources that let GitHub
# Actions authenticate to GCP without static service account keys.

resource "google_project" "cicd_project" {
  name            = "Bootstrap CI/CD"
  project_id      = "bootstrap-cicd"
  org_id          = var.organization_id
  billing_account = var.billing_account_id
  labels = {
    stage      = "bootstrap"
    managed-by = "terraform"
    purpose    = "cicd"
  }
}

resource "google_project_service" "cicd_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com",
  ])

  project = google_project.cicd_project.project_id
  service = each.key

  disable_on_destroy = false
}

# ----------------------------------------------------------------------
# WORKLOAD IDENTITY FEDERATION: GitHub Actions → GCP
# ----------------------------------------------------------------------
# This is the secure bridge between GitHub Actions and GCP.
# GitHub sends a signed OIDC token (its identity document), GCP verifies
# it, and issues a short-lived access token. No service account keys
# are ever stored in GitHub Secrets.

resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = google_project.cicd_project.project_id
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Workload Identity Pool for GitHub Actions CI/CD"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = google_project.cicd_project.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-oidc"
  display_name                       = "GitHub Actions OIDC Provider"
  description                        = "OIDC provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
    "attribute.actor"      = "assertion.actor"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  # Restrict: only this specific repository can authenticate
  attribute_condition = "assertion.repository == '${var.github_organization}/${var.github_repository}'"
}

# ----------------------------------------------------------------------
# WIF → SA IMPERSONATION
# ----------------------------------------------------------------------
# Each stage's service account is granted the ability to be impersonated
# by the Workload Identity Pool. When GitHub Actions runs, it presents
# its OIDC token, GCP verifies it, and allows the workflow to act as
# the specified service account.

resource "google_service_account_iam_member" "wif_sa_impersonation" {
  for_each = google_service_account.stage_sa

  service_account_id = each.value.name
  role               = "roles/iam.workloadIdentityUser"
  member = format(
    "principalSet://iam.googleapis.com/%s/attribute.repository/%s/%s",
    google_iam_workload_identity_pool.github_pool.name,
    var.github_organization,
    var.github_repository,
  )
}

# Also allow the CICD project's default compute SA (optional, for GKE)
# and the state project's SAs to be used in the same pool.

# ----------------------------------------------------------------------
# IAM BINDINGS: Default Editor on State Project
# ----------------------------------------------------------------------
# Give the stage SAs minimal access to the state project so they can
# read/write the Terraform state bucket.

resource "google_storage_bucket_iam_member" "sa_state_bucket_access" {
  for_each = google_service_account.stage_sa

  bucket = google_storage_bucket.terraform_state.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${each.value.email}"
}
