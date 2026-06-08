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

output "vm_external_ip" {
  description = "External IP of the created VM (if create_vm was true)"
  value       = var.create_vm ? module.vm[0].external_ip : null
}

output "vm_internal_ip" {
  description = "Internal IP of the created VM (if create_vm was true)"
  value       = var.create_vm ? module.vm[0].internal_ip : null
}

output "sql_instance_name" {
  description = "Name of the Cloud SQL instance (if create_sql was true)"
  value       = var.create_sql ? module.sql[0].instance_name : null
}

output "sql_public_ip" {
  description = "Public IP of the Cloud SQL instance (if create_sql was true)"
  value       = var.create_sql ? module.sql[0].public_ip : null
}

output "bucket_name" {
  description = "Name of the GCS bucket (if create_bucket was true)"
  value       = var.create_bucket ? module.bucket[0].bucket_name : null
}
