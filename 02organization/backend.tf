# ----------------------------------------------------------------------
# Organization Stage — Backend Configuration (GCS)
# ----------------------------------------------------------------------
#
# Uses the GCS bucket created in bootstrap. State is stored under the
# "organization/" prefix for isolation.
#
# IMPORTANT: After `terraform init -migrate-state` in bootstrap, the
# bucket name must match what was created there. This file uses
# a variable — during `terraform init` you pass:
#   -backend-config="bucket=YOUR_BUCKET_NAME"

terraform {
  backend "gcs" {
    bucket = "PLACEHOLDER-BUCKET-NAME"  # Will be overridden
    prefix = "organization"
  }
}
