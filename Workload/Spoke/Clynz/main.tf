# ======================================================================
# Clynz App — Root Module
# ======================================================================
# Creates the Clynz team's projects and resources.
# Any team member can add custom resources directly below the module call.
# ======================================================================

# Remote state from platform stages
data "terraform_remote_state" "core" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket_name
    prefix = "core"
  }
}

data "terraform_remote_state" "networks" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket_name
    prefix = "networks"
  }
}

locals {
  # Resolve the team folder ID (e.g. "Clynz" → "folders/...")
  team_folder_id = data.terraform_remote_state.core.outputs.team_folder_ids[var.team_name]

  # Get the right subnet for this environment
  subnet_link = data.terraform_remote_state.networks.outputs.subnet_self_links[var.environment]

  # Host project ID from networks stage
  host_project_id = data.terraform_remote_state.networks.outputs.host_project_id
}

# ────────────────────────────────────────────────────────────────────
# SERVICE PROJECT
# ────────────────────────────────────────────────────────────────────
# Creates the project under the team's folder, attaches to Shared VPC.
# The team can choose any project_id they like.

module "project" {
  source = "../../../Modules/service-project"

  project_name          = var.project_component
  project_id            = var.project_id    # Custom ID like "clynz-backend-dev"
  environment           = var.environment
  environment_folder_id = local.team_folder_id
  billing_account_id    = var.billing_account_id
  host_project_id       = local.host_project_id
  subnet_self_link      = local.subnet_link
  apis                  = var.apis
  region                = var.region
  create_vm             = var.create_vm
  create_sql            = var.create_sql
  create_bucket         = var.create_bucket
  vm_machine_type       = var.vm_machine_type
  vm_image              = var.vm_image
}

# ────────────────────────────────────────────────────────────────────
# CUSTOM RESOURCES — Add anything extra below
# ────────────────────────────────────────────────────────────────────
# Examples:
#
# resource "google_container_cluster" "k8s" {
#   name     = "${var.project_id}-cluster"
#   project  = module.project.project_id
#   location = var.region
#   ...
# }
#
# resource "google_compute_disk" "extra" {
#   name    = "${var.project_id}-extra-disk"
#   project = module.project.project_id
#   ...
# }
