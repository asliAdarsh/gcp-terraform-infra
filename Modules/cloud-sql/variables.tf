# ======================================================================
# Cloud SQL Module — Variables
# ======================================================================
# Creates a Cloud SQL (PostgreSQL) instance for application databases.
# ======================================================================

variable "project_id" {
  description = "Project ID where the SQL instance will be created"
  type        = string
}

variable "sql_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
}

variable "region" {
  description = "Region for the Cloud SQL instance"
  type        = string
  default     = "asia-south1"
}

variable "db_version" {
  description = "Database version (e.g. POSTGRES_15, POSTGRES_16, MYSQL_8_0)"
  type        = string
  default     = "POSTGRES_15"
}

variable "db_name" {
  description = "Name of the default database to create"
  type        = string
  default     = "appdb"
}

variable "db_user" {
  description = "Name of the default database user"
  type        = string
  default     = "appuser"
}

variable "tier" {
  description = "Machine tier (e.g. db-f1-micro, db-custom-1-3840)"
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "require_ssl" {
  description = "Require SSL/TLS for all connections"
  type        = bool
  default     = true
}

variable "backup_enabled" {
  description = "Enable automated backups"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Prevent accidental deletion of the instance"
  type        = bool
  default     = true
}
