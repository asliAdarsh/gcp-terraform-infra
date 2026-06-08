# ======================================================================
# Compute VM Module — main.tf
# ======================================================================
# Creates a Linux VM instance with:
#   - No public IP (access via IAP tunnel)
#   - IAP SSH network tag for firewall rule matching
#   - Ubuntu 24.04 boot disk
#   - Optional: assign public IP for testing
# ======================================================================

# ----------------------------------------------------------------------
# STATIC IP (optional)
# ----------------------------------------------------------------------
resource "google_compute_address" "vm_public_ip" {
  count = var.assign_public_ip ? 1 : 0

  name    = "${var.vm_name}-public-ip"
  project = var.project_id
  region  = var.zone != null ? join("-", slice(split("-", var.zone), 0, 2)) : "asia-south1"
}

# ----------------------------------------------------------------------
# VM INSTANCE
# ----------------------------------------------------------------------
resource "google_compute_instance" "vm" {
  name         = var.vm_name
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type

  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size_gb
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link

    dynamic "access_config" {
      for_each = var.assign_public_ip ? [1] : []
      content {
        nat_ip = var.assign_public_ip ? google_compute_address.vm_public_ip[0].address : null
      }
    }
  }

  # Allow IAP SSH and health checks in metadata
  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  labels = {
    managed-by = "terraform"
    vm-type    = "test"
  }
}
