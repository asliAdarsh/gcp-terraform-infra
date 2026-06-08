# ----------------------------------------------------------------------
# Networks Stage — Backend Configuration (GCS)
# ----------------------------------------------------------------------
#
# Uses the GCS bucket created in bootstrap. State under "networks/" prefix.
#
# Initialize with: terraform init -backend-config="bucket=YOUR_BUCKET_NAME"

terraform {
  backend "gcs" {
    bucket = "PLACEHOLDER-BUCKET-NAME"
    prefix = "networks"
  }
}
