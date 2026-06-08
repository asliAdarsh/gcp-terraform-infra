# ======================================================================
# Service Project Module — Outputs
# ======================================================================

output "project_id" {
  description = "Project ID of the created service project"
  value       = google_project.service_project.project_id
}

output "project_number" {
  description = "Project number of the created service project"
  value       = google_project.service_project.number
}

output "project_name" {
  description = "Display name of the created service project"
  value       = google_project.service_project.name
}

output "service_account_email" {
  description = "Default compute service account for the project"
  value       = "${google_project.service_project.number}@cloudservices.gserviceaccount.com"
}
