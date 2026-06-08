terraform {
  backend "gcs" {
    bucket = "PLACEHOLDER-BUCKET-NAME"
    prefix = "apps/backend-api"
  }
}
