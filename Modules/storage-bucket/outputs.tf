# ======================================================================
# Storage Bucket Module — Outputs
# ======================================================================

output "bucket_name" {
  description = "Name of the created bucket"
  value       = google_storage_bucket.bucket.name
}

output "bucket_url" {
  description = "gs:// URL of the bucket"
  value       = "gs://${google_storage_bucket.bucket.name}"
}

output "bucket_self_link" {
  description = "Self-link of the bucket"
  value       = google_storage_bucket.bucket.self_link
}

output "location" {
  description = "Location of the bucket"
  value       = google_storage_bucket.bucket.location
}

output "storage_class" {
  description = "Storage class of the bucket"
  value       = google_storage_bucket.bucket.storage_class
}

output "uniform_bucket_level_access" {
  description = "Whether uniform bucket-level access is enabled"
  value       = google_storage_bucket.bucket.uniform_bucket_level_access
}
