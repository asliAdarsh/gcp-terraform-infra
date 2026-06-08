# ======================================================================
# {TEAM} App — Provider & Backend — TEMPLATE
# ======================================================================
# Change the backend prefix to: spoke/{your-team-name}

provider "google" { region = var.region }

terraform {
  required_version = ">= 1.6"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
    time   = { source = "hashicorp/time", version = "~> 0.12" }
  }
  backend "gcs" {
    bucket = "PLACEHOLDER-BUCKET-NAME"
    prefix = "spoke/YOUR-TEAM-NAME"
  }
}
