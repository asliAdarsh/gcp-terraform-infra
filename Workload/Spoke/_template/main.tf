# ======================================================================
# {TEAM} App — Root Module — TEMPLATE
# ======================================================================
# Copy this folder to Workload/Spoke/{YourTeam}/ and fill in the blanks.
# Then create Deployment/Spoke/{YourTeam}/{env}.tfvars and a workflow.
# ======================================================================

# ── Remote state ──────────────────────────────────────────────────
data "terraform_remote_state" "core" {
  backend = "gcs"
  config = { bucket = var.state_bucket_name, prefix = "core" }
}
data "terraform_remote_state" "networks" {
  backend = "gcs"
  config = { bucket = var.state_bucket_name, prefix = "networks" }
}

locals {
  team_folder_id  = data.terraform_remote_state.core.outputs.team_folder_ids[var.team_name]
  subnet_link     = data.terraform_remote_state.networks.outputs.subnet_self_links[var.environment]
  host_project_id = data.terraform_remote_state.networks.outputs.host_project_id
}

# ── Base project (creates project + attaches to Shared VPC) ──────
module "project" {
  source = "../../../Modules/service-project"

  project_name          = var.project_component
  project_id            = var.project_id
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

# ── YOUR CUSTOM RESOURCES GO HERE ─────────────────────────────────
# Examples:
#
# resource "google_container_cluster" "k8s" {
#   name     = "${var.project_id}-cluster"
#   project  = module.project.project_id
#   location = var.region
#   ...
# }
