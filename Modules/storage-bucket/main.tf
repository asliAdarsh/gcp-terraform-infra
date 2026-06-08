# ======================================================================
# Storage Bucket Module — main.tf
# ======================================================================
# Creates a GCS bucket with:
#   - Uniform bucket-level access (no per-object ACLs)
#   - Object versioning (data recovery)
#   - Lifecycle rules (optional retention/archival)
#   - Encryption with Google-managed key (default)
# ======================================================================

resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  project       = var.project_id
  location      = var.location
  storage_class = var.storage_class

  # Prevent public access
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  # Enable versioning for data protection
  versioning {
    enabled = var.enable_versioning
  }

  # Lifecycle: move to NEARLINE after 90 days, COLDLINE after 365, delete after 1095
  lifecycle_rule {
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition {
      age = 90
    }
  }

  lifecycle_rule {
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
    condition {
      age = 365
    }
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 1095  # 3 years
    }
  }

  # Retention policy (optional — uncomment to enforce minimum retention)
  # retention_policy {
  #   retention_period = 86400  # 1 day in seconds
  # }

  force_destroy = var.force_destroy

  labels = merge(var.labels, {
    managed-by = "terraform"
  })
}
