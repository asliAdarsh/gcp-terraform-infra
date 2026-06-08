# ----------------------------------------------------------------------
# Bootstrap Stage — Provider Configuration
# ----------------------------------------------------------------------
#
# Uses your locally-authenticated service account to create resources.
# This is the ONLY stage that uses local state (backend.tf will be updated
# after the first `terraform apply` to migrate to the new GCS bucket).

provider "google" {
  region = var.region
}
