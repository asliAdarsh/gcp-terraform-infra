# Clynz Team App — Outputs

output "project_id" {
  description = "Created project ID"
  value       = module.project.project_id
}

output "project_number" {
  description = "Created project number"
  value       = module.project.project_number
}

output "vm_internal_ip" {
  description = "VM internal IP (if created)"
  value       = module.project.vm_internal_ip
}

output "vm_external_ip" {
  description = "VM external IP (if created)"
  value       = module.project.vm_external_ip
}

output "bucket_name" {
  description = "Bucket name (if created)"
  value       = module.project.bucket_name
}
