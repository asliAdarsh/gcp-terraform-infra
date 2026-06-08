# Frontend Web — Variables

variable "environment"       { type = string }
variable "organization_id"    { type = string }
variable "billing_account_id" { type = string }
variable "state_bucket_name"  { type = string }
variable "region"             { type = string, default = "asia-south1" }

variable "apis" {
  type    = list(string)
  default = ["compute.googleapis.com", "run.googleapis.com"]
}

variable "create_vm"    { type = bool, default = false }
variable "create_sql"   { type = bool, default = false }
variable "create_bucket" { type = bool, default = true }
