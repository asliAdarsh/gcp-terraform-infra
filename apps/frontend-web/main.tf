# ======================================================================
# frontend-web — Root Module
# ======================================================================
# Creates the frontend-web service project with a storage bucket.
# ======================================================================

data "terraform_remote_state" "organization" {
  backend = "gcs"
  config = { bucket = var.state_bucket_name, prefix = "organization" }
}

data "terraform_remote_state" "networks" {
  backend = "gcs"
  config = { bucket = var.state_bucket_name, prefix = "networks" }
}

locals {
  env_folder_id   = data.terraform_remote_state.organization.outputs.env_folder_ids[var.environment]
  host_project_id = data.terraform_remote_state.networks.outputs.host_project_id
  subnet_link     = data.terraform_remote_state.networks.outputs.subnet_self_links[var.environment]
}

module "project" {
  source = "../../Modules/service-project"

  project_name          = "frontend-web"
  environment           = var.environment
  environment_folder_id = local.env_folder_id
  billing_account_id    = var.billing_account_id
  host_project_id       = local.host_project_id
  subnet_self_link      = local.subnet_link
  apis                  = var.apis
  region                = var.region
  create_vm             = var.create_vm
  create_sql            = var.create_sql
  create_bucket         = var.create_bucket
}
