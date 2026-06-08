# ======================================================================
# Service Project Module — main.tf
# ======================================================================
# Creates a complete service project:
#   1. GCP project under environment folder
#   2. Required APIs enabled
#   3. Shared VPC attachment to host project
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
# Attach this project as a service project to the host VPC.
# Once attached, resources in this project can use the host VPC's subnets.
# Access to specific subnets can be controlled via subnet-level IAM.
resource "google_compute_shared_vpc_service_project" "attachment" {
  host_project    = var.host_project_id
  service_project = google_project.service_project.project_id

  depends_on = [google_project_service.api]
}
