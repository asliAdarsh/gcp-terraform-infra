# ======================================================================
# Service Projects Stage — Outputs
# ======================================================================

output "project_ids" {
  description = "Map of created project IDs keyed by project name"
  value = {
    for k, mod in module.service_project : k => mod.project_id
  }
}

output "project_numbers" {
  description = "Map of created project numbers keyed by project name"
  value = {
    for k, mod in module.service_project : k => mod.project_number
  }
}

output "environment" {
  description = "Current environment being deployed"
  value       = var.environment
}
