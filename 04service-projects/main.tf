# ======================================================================
# Service Projects Stage — main.tf
# ======================================================================
#
# Purpose: Create one or more service projects under the environment
# folder, each attached to the Shared VPC with the right subnet.
#
# This stage is called ONCE PER ENVIRONMENT by passing a different
# .tfvars file each time:
#
#   terraform apply -var-file=../Deployment/dev.tfvars
#   terraform apply -var-file=../Deployment/staging.tfvars
#   terraform apply -var-file=../Deployment/prod.tfvars
#
# This is Stage 4 of 4. Must run AFTER bootstrap, organization, networks.
#
# ======================================================================

# ----------------------------------------------------------------------
# Remote State: Read outputs from Organization + Networks stages
# ----------------------------------------------------------------------
data "terraform_remote_state" "organization" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket_name
    prefix = "organization"
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
  # Pull folder IDs and subnet links from previous stages
  env_folder_id    = data.terraform_remote_state.organization.outputs.env_folder_ids[var.environment]
  host_project_id  = data.terraform_remote_state.networks.outputs.host_project_id
  subnet_self_link = data.terraform_remote_state.networks.outputs.subnet_self_links[var.environment]
}

# ----------------------------------------------------------------------
# SERVICE PROJECTS (one per entry in service_projects list)
# ----------------------------------------------------------------------
module "service_project" {
  source = "../Modules/service-project"

  for_each = {
    for p in var.service_projects : p.name => p
  }

  project_name           = each.key
  environment            = var.environment
  environment_folder_id  = local.env_folder_id
  billing_account_id     = var.billing_account_id
  host_project_id        = local.host_project_id
  subnet_self_link       = local.subnet_self_link
  apis                   = each.value.apis
  region                 = var.region
  create_vm              = each.value.create_vm
  create_sql             = each.value.create_sql
  create_bucket          = each.value.create_bucket
}
