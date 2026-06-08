# ======================================================================
# Service Project Module — Variables
# ======================================================================

variable "project_name" {
  description = "Short name for the project (e.g. backend-api, frontend-web)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "environment_folder_id" {
  description = "Folder ID where the project will be created (e.g. folders/1234567890)"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account ID to link to the project"
  type        = string
}

variable "host_project_id" {
  description = "Project ID of the Shared VPC host project"
  type        = string
}

variable "subnet_self_link" {
  description = "Self-link of the subnet to attach this project to"
  type        = string
}

variable "apis" {
  description = "List of Google APIs to enable on the project"
  type        = list(string)
  default     = ["compute.googleapis.com"]
}

variable "region" {
  description = "Default region for resources"
  type        = string
  default     = "asia-south1"
}

variable "create_vm" {
  description = "If true, create a test VM instance in the project"
  type        = bool
  default     = false
}

variable "create_sql" {
  description = "If true, create a Cloud SQL (PostgreSQL) instance in the project"
  type        = bool
  default     = false
}

variable "create_bucket" {
  description = "If true, create a GCS storage bucket in the project"
  type        = bool
  default     = false
}
