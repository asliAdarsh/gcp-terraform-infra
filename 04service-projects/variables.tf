# ----------------------------------------------------------------------
# Service Projects Stage — Input Variables
# ----------------------------------------------------------------------

variable "environment" {
  description = "Environment name (dev, staging, prod). Set via .tfvars file."
  type        = string
}

variable "organization_id" {
  description = "Your GCP Organization ID"
  type        = string
}

variable "billing_account_id" {
  description = "Your GCP Billing Account ID"
  type        = string
}

variable "state_bucket_name" {
  description = "Name of the GCS bucket from bootstrap"
  type        = string
}

variable "region" {
  description = "Default region for GCP resources"
  type        = string
  default     = "asia-south1"
}

variable "service_projects" {
  description = <<-EOT
    List of service projects to create in this environment.
    Each entry: { name, apis }
    Example:
    service_projects = [
      { name = "backend-api", apis = ["compute.googleapis.com", "container.googleapis.com"] },
      { name = "frontend-web", apis = ["compute.googleapis.com", "run.googleapis.com"] },
    ]
  EOT
  type = list(object({
    name = string
    apis = optional(list(string), ["compute.googleapis.com"])
  }))
}
