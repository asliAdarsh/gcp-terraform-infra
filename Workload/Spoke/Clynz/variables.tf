# Clynz Team App — Variables

variable "team_name" {
  description = "Team name (must match Core folder name, e.g. Clynz)"
  type        = string
}

variable "project_component" {
  description = "Component name for display (e.g. backend, frontend)"
  type        = string
}

variable "project_id" {
  description = "Custom project ID (e.g. clynz-backend-dev)"
  type        = string
}

variable "environment" {
  description = "Environment: dev, staging, or prod"
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

variable "organization_id" {
  description = "GCP Organization ID"
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

variable "vm_machine_type" {
  description = "VM machine type"
  type        = string
  default     = "e2-micro"
}

variable "vm_image" {
  description = "VM boot disk image"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
}
