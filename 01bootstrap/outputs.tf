# ======================================================================
# Bootstrap Stage — Outputs
# ======================================================================
#
# These values are consumed by ALL downstream stages (organization,
# networks, service-projects). Each downstream stage reads these via
# terraform_remote_state data sources.
#
# ======================================================================

# ----------------------------------------------------------------------
# GCS State Bucket
# ----------------------------------------------------------------------
output "state_bucket_name" {
  description = "Name of the GCS bucket storing all Terraform state files"
  value       = google_storage_bucket.terraform_state.name
}

output "state_bucket_url" {
  description = "Full gs:// URL of the state bucket (useful for gsutil commands)"
  value       = "gs://${google_storage_bucket.terraform_state.name}"
}

# ----------------------------------------------------------------------
# Service Accounts
# ----------------------------------------------------------------------
output "terraform_org_sa_email" {
  description = "Service account email for the Organization stage"
  value       = google_service_account.stage_sa["terraform-org"].email
}

output "terraform_networks_sa_email" {
  description = "Service account email for the Networks stage"
  value       = google_service_account.stage_sa["terraform-networks"].email
}

output "terraform_service_projects_sa_email" {
  description = "Service account email for the Service Projects stage"
  value       = google_service_account.stage_sa["terraform-service-projects"].email
}

output "all_service_account_emails" {
  description = "Map of all stage service account emails (keyed by stage name)"
  value = {
    for k, sa in google_service_account.stage_sa : k => sa.email
  }
}

# ----------------------------------------------------------------------
# Workload Identity Federation
# ----------------------------------------------------------------------
output "workload_identity_pool_name" {
  description = "Full resource name of the WIF pool (used in GitHub Actions 'google-github-actions/auth' action)"
  value       = google_iam_workload_identity_pool.github_pool.name
}

output "workload_identity_pool_id" {
  description = "Short ID of the WIF pool"
  value       = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
}

output "workload_identity_provider_name" {
  description = "Full resource name of the WIF provider (needed for GitHub Actions configuration)"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}

# ----------------------------------------------------------------------
# Project IDs
# ----------------------------------------------------------------------
output "state_project_id" {
  description = "Project ID of the bootstrap-infra-state project"
  value       = google_project.state_project.project_id
}

output "cicd_project_id" {
  description = "Project ID of the bootstrap-cicd project"
  value       = google_project.cicd_project.project_id
}

# ----------------------------------------------------------------------
# Stage-to-SA Mapping (for documentation)
# ----------------------------------------------------------------------
output "stage_to_service_account" {
  description = "Which service account to use for each Terraform stage"
  value = {
    org              = google_service_account.stage_sa["terraform-org"].email
    networks         = google_service_account.stage_sa["terraform-networks"].email
    service-projects = google_service_account.stage_sa["terraform-service-projects"].email
  }
}
