# ======================================================================
# Storage Bucket Module — Variables
# ======================================================================
# Creates a GCS bucket with standardized security and lifecycle settings.
# ======================================================================

variable "project_id" {
  description = "Project ID where the bucket will be created"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique name for the bucket"
  type        = string
}

variable "location" {
  description = "Location for the bucket. Use the same region as other resources (e.g. asia-south1) or a multi-region (US, EU, ASIA)"
  type        = string
  default     = "asia-south1"
}

variable "storage_class" {
  description = "Storage class (STANDARD, NEARLINE, COLDLINE, ARCHIVE)"
  type        = string
  default     = "STANDARD"
}

variable "force_destroy" {
  description = "Allow deletion of non-empty bucket"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable object versioning for data protection"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to attach to the bucket"
  type        = map(string)
  default     = {}
}
