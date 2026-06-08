# ======================================================================
# Cloud SQL Module — main.tf
# ======================================================================
# Creates:
#   - Cloud SQL PostgreSQL instance (private IP, no public access)
#   - Default database
#   - Default user
# ======================================================================

# ----------------------------------------------------------------------
# CLOUD SQL INSTANCE
# ----------------------------------------------------------------------
resource "google_sql_database_instance" "sql" {
  name             = var.sql_name
  project          = var.project_id
  region           = var.region
  database_version = var.db_version

  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    disk_size         = var.disk_size_gb
    disk_type         = "PD_SSD"
    disk_autoresize   = true
    activation_policy = "ALWAYS"

    ip_configuration {
      # Private IP only — no public access
      ipv4_enabled = false
    }

    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = "03:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
    }

    # Enable insights for performance monitoring
    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }

    # Maintenance window (early morning)
    maintenance_window {
      day          = 1  # Monday
      hour         = 3  # 3:00 AM
      update_track = "stable"
    }
  }
}

# ----------------------------------------------------------------------
# DEFAULT DATABASE
# ----------------------------------------------------------------------
resource "google_sql_database" "database" {
  name     = var.db_name
  project  = var.project_id
  instance = google_sql_database_instance.sql.name
}

# ----------------------------------------------------------------------
# DEFAULT USER
# ----------------------------------------------------------------------
# Generate a random password for the database user
resource "random_password" "db_password" {
  length  = 24
  special = false
  keepers = {
    sql_instance = google_sql_database_instance.sql.name
  }
}

resource "google_sql_user" "user" {
  name     = var.db_user
  project  = var.project_id
  instance = google_sql_database_instance.sql.name
  password = random_password.db_password.result
}
