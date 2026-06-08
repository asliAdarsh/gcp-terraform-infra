# ======================================================================
# Cloud SQL Module — Outputs
# ======================================================================

output "instance_name" {
  description = "Name of the Cloud SQL instance"
  value       = google_sql_database_instance.sql.name
}

output "instance_self_link" {
  description = "Self-link of the Cloud SQL instance"
  value       = google_sql_database_instance.sql.self_link
}

output "private_ip" {
  description = "Private IP address of the Cloud SQL instance"
  value       = google_sql_database_instance.sql.private_ip_address
}

output "public_ip" {
  description = "Public IP address of the Cloud SQL instance (null if ipv4_enabled=false)"
  value       = google_sql_database_instance.sql.public_ip_address
}

output "database_name" {
  description = "Name of the created database"
  value       = google_sql_database.database.name
}

output "db_user_name" {
  description = "Name of the created database user"
  value       = google_sql_user.user.name
}

output "db_password" {
  description = "Password of the created database user (sensitive)"
  value       = random_password.db_password.result
  sensitive   = true
}

output "version" {
  description = "Database version running on the instance"
  value       = google_sql_database_instance.sql.database_version
}
