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
    Each entry: { name, apis, create_vm, create_sql, create_bucket }
    Example:
    service_projects = [
      {
        name        = "backend-api"
        apis        = ["compute.googleapis.com"]
        create_vm   = true
        create_sql  = false
        create_bucket = true
      },
    ]
  EOT
  type = list(object({
    name          = string
    apis          = optional(list(string), ["compute.googleapis.com"])
    create_vm     = optional(bool, false)
    create_sql    = optional(bool, false)
    create_bucket = optional(bool, false)
  }))
}
