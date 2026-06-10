# ----------------------------------------------------------------------
# Networks Stage — Input Variables
# ----------------------------------------------------------------------

variable "organization_id" {
  description = "Your GCP Organization ID (numeric)"
  type        = string
}

variable "billing_account_id" {
  description = "Your GCP Billing Account ID"
  type        = string
}

variable "state_bucket_name" {
  description = "Name of the GCS bucket created in bootstrap (e.g. YOUR_STATE_BUCKET)"
  type        = string
}

variable "region" {
  description = "Default region for GCP resources"
  type        = string
  default     = "asia-south1"
}
