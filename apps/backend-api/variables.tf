# Backend API — Variables

variable "environment" {
  description = "Environment: dev, staging, or prod"
  type        = string
}

variable "organization_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "billing_account_id" {
  description = "GCP Billing Account ID"
  type        = string
}

variable "state_bucket_name" {
  description = "GCS state bucket from bootstrap"
  type        = string
}

variable "region" {
  description = "Default region"
  type        = string
  default     = "asia-south1"
}

variable "apis" {
  description = "APIs to enable on the project"
  type        = list(string)
  default     = ["compute.googleapis.com"]
}

variable "create_vm" {
  description = "Create a test VM"
  type        = bool
  default     = false
}

variable "create_sql" {
  description = "Create a Cloud SQL instance"
  type        = bool
  default     = false
}

variable "create_bucket" {
  description = "Create a storage bucket"
  type        = bool
  default     = false
}
