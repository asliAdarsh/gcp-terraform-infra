variable "environment"       { type = string }
variable "organization_id"    { type = string }
variable "billing_account_id" { type = string }
variable "state_bucket_name"  { type = string }
variable "region"             { type = string, default = "asia-south1" }
variable "apis" {
  type    = list(string)
  default = ["compute.googleapis.com", "dataflow.googleapis.com"]
}
variable "create_vm"    { type = bool, default = false }
variable "create_sql"   { type = bool, default = false }
variable "create_bucket" { type = bool, default = true }

output "project_id"   { value = module.project.project_id }
output "project_number" { value = module.project.project_number }
output "bucket_name"  { value = module.project.bucket_name }

provider "google" { region = var.region }

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
  backend "gcs" {
    bucket = "PLACEHOLDER-BUCKET-NAME"
    prefix = "apps/data-pipeline"
  }
}
