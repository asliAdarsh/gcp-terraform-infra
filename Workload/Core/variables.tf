# Core Stage — Variables

variable "environment" {
  description = "Environment for this deployment (dev, staging, prod)"
  type        = string
}

variable "organization_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "state_bucket_name" {
  description = "GCS state bucket from bootstrap"
  type        = string
}

variable "teams" {
  description = "List of team names to create folders for (e.g. ['Clynz', 'Alpha'])"
  type        = list(string)
}
