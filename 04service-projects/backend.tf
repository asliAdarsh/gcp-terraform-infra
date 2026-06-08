# ----------------------------------------------------------------------
# Service Projects Stage — Backend Configuration (GCS)
# ----------------------------------------------------------------------
#
# Initialize with: terraform init -backend-config="bucket=YOUR_BUCKET_NAME"
# The prefix includes the environment to keep state isolated per env.

terraform {
  backend "gcs" {
    bucket = "PLACEHOLDER-BUCKET-NAME"
    prefix = "service-projects"  # Per-environment state in the workspace
  }
}
