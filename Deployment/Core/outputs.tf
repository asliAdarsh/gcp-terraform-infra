# Core Stage — Outputs

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
