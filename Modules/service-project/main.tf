# ======================================================================
# Service Project Module — main.tf
# ======================================================================
# Creates a complete service project with optional resources:
#   - GCP project under specified folder
#   - Required APIs enabled
#   - Shared VPC attachment to host project
#   - Optional: VM instance, Cloud SQL, Storage bucket
# ======================================================================

# ----------------------------------------------------------------------
# GCP PROJECT
# ----------------------------------------------------------------------
locals {
  resolved_project_id = var.project_id != null ? var.project_id : "sb-${var.environment}-${var.project_name}"
}

resource "google_project" "service_project" {
  name            = "${var.environment}-${var.project_name}"
  project_id      = local.resolved_project_id
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
resource "time_sleep" "api_propagation" {
  count = var.create_vm || var.create_sql ? 1 : 0

  create_duration = "30s"
  depends_on      = [google_project_service.api]
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
  machine_type      = var.vm_machine_type
  image             = var.vm_image
  tags              = ["iap-ssh", var.environment]

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
  bucket_name = "${var.environment}-${var.project_name}-data"
  location    = var.region
}
