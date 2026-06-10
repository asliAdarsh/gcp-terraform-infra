# ----------------------------------------------------------------------
# Organization Stage — Input Variables
# ----------------------------------------------------------------------

variable "organization_id" {
  description = "Your GCP Organization ID (numeric). From: gcloud organizations list"
  type        = string
}

variable "billing_account_id" {
  description = "Your GCP Billing Account ID. From: gcloud billing accounts list"
  type        = string
}

variable "state_bucket_name" {
  description = "Name of the GCS bucket created in bootstrap (e.g. YOUR_STATE_BUCKET)"
  type        = string
}

variable "terraform_org_sa_email" {
  description = "Service account email for the org stage (from bootstrap output: terraform_org_sa_email)"
  type        = string
}

variable "region" {
  description = "Default region for GCP resources"
  type        = string
  default     = "asia-south1"
}
