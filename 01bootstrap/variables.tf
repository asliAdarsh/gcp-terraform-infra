# ----------------------------------------------------------------------
# Bootstrap Stage — Input Variables
# ----------------------------------------------------------------------

variable "organization_id" {
  description = "Your GCP Organization ID (numeric). Get it from: gcloud organizations list"
  type        = string
}

variable "billing_account_id" {
  description = "Your GCP Billing Account ID. Get it from: gcloud billing accounts list"
  type        = string
}

variable "state_bucket_name" {
  description = <<-EOT
    Globally unique name for the GCS bucket that will store all Terraform state files.
    Convention: terraform-state-<your-org>-<random-suffix>
    Example: terraform-state-mycompany-9x4k
    Rules: 3-63 chars, lowercase letters, numbers, hyphens only. No underscores.
  EOT
  type        = string
}

variable "github_organization" {
  description = "Your GitHub organization or username (e.g. 'adarsh' or 'my-org')"
  type        = string
}

variable "github_repository" {
  description = "Your GitHub repository name (e.g. 'gcp-iac-devsecops')"
  type        = string
}

variable "region" {
  description = "Default region for GCP resources (e.g. asia-south1, us-central1)"
  type        = string
  default     = "asia-south1"
}
