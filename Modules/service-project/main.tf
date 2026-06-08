# ======================================================================
# Service Project Module — main.tf
# ======================================================================
# Creates a complete service project with optional resources:
#   - GCP project under environment folder
#   - Required APIs enabled
#   - Shared VPC attachment to host project
#   - Optional: VM instance (compute-vm module)
#   - Optional: Cloud SQL instance (cloud-sql module)
#   - Optional: GCS storage bucket (storage-bucket module)
# ======================================================================

# ----------------------------------------------------------------------
# GCP PROJECT
# ----------------------------------------------------------------------
resource "google_project" "service_project" {
  name            = "${var.environment}-${var.project_name}"
  project_id      = "sb-${var.environment}-${var.project_name}"
  folder_id       = var.environment_folder_id
  billing_account = var.billing_account_id

  labels = {
    environment = var.environment
    project     = var.project_name
    managed-by  = "terraform"
    stage       = "service-projects"
  }

  deletion_policy = "PREVENT"
}

# ----------------------------------------------------------------------
# ENABLE APIs
# ----------------------------------------------------------------------
resource "google_project_service" "api" {
  for_each = toset(var.apis)

  project = google_project.service_project.project_id
  service = each.key

  disable_on_destroy = false
}

# ----------------------------------------------------------------------
# SHARED VPC ATTACHMENT
# ----------------------------------------------------------------------
resource "google_compute_shared_vpc_service_project" "attachment" {
  host_project    = var.host_project_id
  service_project = google_project.service_project.project_id

  depends_on = [google_project_service.api]
}

# ----------------------------------------------------------------------
# WAIT FOR API PROPAGATION
# ----------------------------------------------------------------------
# Newly enabled APIs take ~30s to propagate. Without this wait,
# resources like VMs fail with "Compute API not enabled yet".
resource "time_sleep" "api_propagation" {
  count = var.create_vm || var.create_sql ? 1 : 0

  create_duration = "30s"

  depends_on = [google_project_service.api]
}

# ----------------------------------------------------------------------
# OPTIONAL: VM INSTANCE
# ----------------------------------------------------------------------
module "vm" {
  count = var.create_vm ? 1 : 0

  source = "../compute-vm"

  project_id        = google_project.service_project.project_id
  vm_name           = "${var.environment}-${var.project_name}-vm"
  zone              = "${var.region}-a"
  subnet_self_link  = var.subnet_self_link
  machine_type      = "e2-micro"
  tags              = ["iap-ssh", "${var.environment}"]

  depends_on = [time_sleep.api_propagation[0]]
}

# ----------------------------------------------------------------------
# OPTIONAL: CLOUD SQL (PostgreSQL)
# ----------------------------------------------------------------------
module "sql" {
  count = var.create_sql ? 1 : 0

  source = "../cloud-sql"

  project_id  = google_project.service_project.project_id
  sql_name    = "${var.environment}-${var.project_name}-sql"
  region      = var.region
  db_version  = "POSTGRES_15"
  db_name     = "appdb"
  db_user     = "appuser"

  depends_on = [time_sleep.api_propagation[0]]
}

# ----------------------------------------------------------------------
# OPTIONAL: STORAGE BUCKET
# ----------------------------------------------------------------------
module "bucket" {
  count = var.create_bucket ? 1 : 0

  source = "../storage-bucket"

  project_id  = google_project.service_project.project_id
  bucket_name = "sb-${var.environment}-${var.project_name}-data"
  location    = var.region
}
