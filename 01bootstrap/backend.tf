# ----------------------------------------------------------------------
# Bootstrap Stage — Backend Configuration
# ----------------------------------------------------------------------
#
# Bootstrap uses LOCAL state because the GCS bucket doesn't exist yet.
# After `terraform apply`, run `terraform init -migrate-state` to move
# state to the newly created bucket.
#
# All subsequent stages will use this template pointing to the bucket:

# terraform {
#   backend "gcs" {
#     bucket = "YOUR_STATE_BUCKET_NAME"
#     prefix = "terraform/organization"
#   }
# }

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
