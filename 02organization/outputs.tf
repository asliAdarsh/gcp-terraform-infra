# ======================================================================
# Organization Stage — Outputs
# ======================================================================
#
# These values are consumed by the Networks and Service Projects stages.
#
# ======================================================================

# ----------------------------------------------------------------------
# Folder IDs
# ----------------------------------------------------------------------
output "platform_folder_id" {
  description = "ID of the f-platform folder (e.g. folders/1234567890)"
  value       = google_folder.environment["platform"].id
}

output "env_folder_ids" {
  description = "Map of environment folder IDs (dev, staging, prod)"
  value = {
    for k, folder in google_folder.environment : k => folder.id
    if k != "platform"
  }
}

output "all_folder_ids" {
  description = "Map of ALL folder IDs including platform"
  value = {
    for k, folder in google_folder.environment : k => folder.id
  }
}

# ----------------------------------------------------------------------
# Host Project
# ----------------------------------------------------------------------
output "host_project_id" {
  description = "Project ID of the Shared VPC host project (host-platform)"
  value       = google_project.host_project.project_id
}

output "host_project_number" {
  description = "Project number of the host project (needed for some IAM bindings)"
  value       = google_project.host_project.number
}

# ----------------------------------------------------------------------
# Service Account (for reference / CI/CD)
# ----------------------------------------------------------------------
output "terraform_org_sa_email" {
  description = "Service account used for this stage (same as bootstrap input)"
  value       = var.terraform_org_sa_email
}
