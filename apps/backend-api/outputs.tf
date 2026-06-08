# Backend API — Outputs

output "project_id" {
  description = "Project ID of the service project"
  value       = module.project.project_id
}

output "project_number" {
  description = "Project number"
  value       = module.project.project_number
}

output "vm_internal_ip" {
  description = "Internal IP of the VM (if created)"
  value       = module.project.vm_internal_ip
}

output "vm_external_ip" {
  description = "External IP of the VM (if created)"
  value       = module.project.vm_external_ip
}

output "sql_instance_name" {
  description = "Cloud SQL instance name (if created)"
  value       = module.project.sql_instance_name
}

output "bucket_name" {
  description = "Storage bucket name (if created)"
  value       = module.project.bucket_name
}
