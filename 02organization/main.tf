# ======================================================================
# Organization Stage — main.tf
# ======================================================================
#
# Purpose: Create the GCP resource hierarchy (folders), the Shared VPC
# host project, organization-level IAM bindings, and org policies.
#
# This is Stage 2 of 4. Must run AFTER bootstrap.
#
# ======================================================================

# ----------------------------------------------------------------------
# LOCALS
# ----------------------------------------------------------------------
locals {
  # Defines the four folders we create.
  # Using a map (not a list) allows referencing by key later.
  environments = {
    platform = { display_name = "f-platform" }
    dev      = { display_name = "f-dev" }
    staging  = { display_name = "f-staging" }
    prod     = { display_name = "f-prod" }
  }
}

# ----------------------------------------------------------------------
# FOLDERS
# ----------------------------------------------------------------------
# Each folder groups projects with similar access and policy requirements.
# Folders are created directly under the organization root.

resource "google_folder" "environment" {
  for_each     = local.environments
  display_name = each.value.display_name
  parent       = "organizations/${var.organization_id}"
}

# ----------------------------------------------------------------------
# SHARED VPC HOST PROJECT
# ----------------------------------------------------------------------
# This project will host the Shared VPC (created in the Networks stage).
# It lives inside the f-platform folder.

resource "google_project" "host_project" {
  name            = "Shared VPC Host Project"
  project_id      = "host-platform"
  folder_id       = google_folder.environment["platform"].id
  billing_account = var.billing_account_id
  labels = {
    stage        = "organization"
    managed-by   = "terraform"
    project-type = "host"
  }
}

# Enable APIs required on the host project
resource "google_project_service" "host_project_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "dns.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "networking.googleapis.com",
  ])

  project              = google_project.host_project.project_id
  service              = each.key
  disable_on_destroy   = false
}

# ----------------------------------------------------------------------
# ORGANIZATION IAM BINDINGS
# ----------------------------------------------------------------------
# Grant the stage service accounts the roles they need to operate.
# These are granted at the organization level (apply to everything).

# The org SA can manage folders
resource "google_organization_iam_member" "org_sa_folder_admin" {
  org_id = var.organization_id
  role   = "roles/resourcemanager.folderAdmin"
  member = "serviceAccount:${var.terraform_org_sa_email}"
}

# The org SA can create projects
resource "google_organization_iam_member" "org_sa_project_creator" {
  org_id = var.organization_id
  role   = "roles/resourcemanager.projectCreator"
  member = "serviceAccount:${var.terraform_org_sa_email}"
}

# The org SA can assign IAM on projects
resource "google_organization_iam_member" "org_sa_project_iam_admin" {
  org_id = var.organization_id
  role   = "roles/resourcemanager.projectIamAdmin"
  member = "serviceAccount:${var.terraform_org_sa_email}"
}

# The org SA can link billing accounts
resource "google_organization_iam_member" "org_sa_billing_user" {
  org_id = var.organization_id
  role   = "roles/billing.user"
  member = "serviceAccount:${var.terraform_org_sa_email}"
}

# ----------------------------------------------------------------------
# FOLDER-LEVEL IAM BINDINGS
# ----------------------------------------------------------------------

# Grant networks SA access to the platform folder (for VPC management)
resource "google_folder_iam_member" "platform_folder_network_admin" {
  folder = google_folder.environment["platform"].id
  role   = "roles/compute.networkAdmin"
  member = "serviceAccount:${var.terraform_org_sa_email}"
}

# Grant networks SA security admin on platform folder (for firewall rules)
resource "google_folder_iam_member" "platform_folder_security_admin" {
  folder = google_folder.environment["platform"].id
  role   = "roles/compute.securityAdmin"
  member = "serviceAccount:${var.terraform_org_sa_email}"
}

# Mark host project as a Shared VPC host
resource "google_compute_shared_vpc_host_project" "host_project" {
  project = google_project.host_project.project_id
}

# ----------------------------------------------------------------------
# ORGANIZATION POLICIES
# ----------------------------------------------------------------------
# These policies set guardrails for the entire organization.
# They prevent common misconfigurations and security issues.

# Policy: Disable VM external IP addresses
# Policy: Disable VM external IP addresses (reset to inherit org default)
resource "google_org_policy_policy" "vm_external_ip" {
  name   = "organizations/${var.organization_id}/policies/compute.vmExternalIpAccess"
  parent = "organizations/${var.organization_id}"

  spec {
    inherit_from_parent = false
    reset               = true
  }
}

# Policy: Enforce domain-restricted sharing
# Allows only users from specified domains to receive IAM roles
resource "google_org_policy_policy" "domain_restricted_sharing" {
  name   = "organizations/${var.organization_id}/policies/iam.allowedPolicyMemberDomains"
  parent = "organizations/${var.organization_id}"

  spec {
    inherit_from_parent = false
    rules {
      values {
        allowed_values = [
          "gmail.com",
          # Replace with your Cloud Identity customer ID if using a custom domain
          # "C01234567",
        ]
      }
    }
  }
}

# Policy: Require Shielded VM for all instances
resource "google_org_policy_policy" "shielded_vm" {
  name   = "organizations/${var.organization_id}/policies/compute.requireShieldedVm"
  parent = "organizations/${var.organization_id}"

  spec {
    inherit_from_parent = false
    rules {
      enforce = true
    }
  }
}

# Policy: Enforce uniform bucket-level access
resource "google_org_policy_policy" "uniform_bucket_access" {
  name   = "organizations/${var.organization_id}/policies/storage.uniformBucketLevelAccess"
  parent = "organizations/${var.organization_id}"

  spec {
    inherit_from_parent = false
    rules {
      enforce = true
    }
  }
}
