# ======================================================================
# {TEAM} App — Variables — TEMPLATE
# ======================================================================

variable "team_name" {
  description = "Your team name (must match Core folder, e.g. Clynz)"
  type        = string
}

variable "project_component" {
  description = "Component name (e.g. backend, frontend)"
  type        = string
}

variable "project_id" {
  description = "Custom project ID (e.g. totes-backend-dev)"
  type        = string
}

variable "environment" {
  description = "Environment: dev, staging, or prod"
  type        = string
}

# ── From common.tfvars ────────────────────────────────────────────
variable "billing_account_id" { type = string }
variable "state_bucket_name"  { type = string }
variable "region"             { type = string, default = "asia-south1" }

# ── Optional flags ────────────────────────────────────────────────
variable "apis" {
  type    = list(string)
  default = ["compute.googleapis.com"]
}
variable "create_vm"    { type = bool, default = false }
variable "create_sql"   { type = bool, default = false }
variable "create_bucket" { type = bool, default = false }
variable "vm_machine_type" { type = string, default = "e2-micro" }
variable "vm_image" { type = string, default = "ubuntu-os-cloud/ubuntu-2404-lts-amd64" }
