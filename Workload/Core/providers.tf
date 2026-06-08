provider "google" { region = "asia-south1" }

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
  backend "gcs" {
    bucket = "PLACEHOLDER-BUCKET-NAME"
    prefix = "core"
  }
}
