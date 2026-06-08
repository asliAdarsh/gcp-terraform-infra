# ======================================================================
# Core Stage — main.tf
# ======================================================================
# Creates team sub-folders under ONE environment folder (dev/staging/prod).
# Run once per environment with the matching .tfvars.
# ======================================================================

data "terraform_remote_state" "organization" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket_name
    prefix = "organization"
  }
}

locals {
  # Get the folder ID for the current environment (e.g. f-dev)
  env_folder_id = data.terraform_remote_state.organization.outputs.env_folder_ids[var.environment]
}

# Create a sub-folder for each team under this environment's folder
resource "google_folder" "team" {
  for_each = toset(var.teams)

  display_name = each.key
  parent       = local.env_folder_id
}

output "team_folder_ids" {
  description = "Map of team folder IDs for this environment: {team-name => folders/ID}"
  value = {
    for team, folder in google_folder.team : team => folder.id
  }
}

output "environment" {
  description = "Current environment"
  value       = var.environment
}
