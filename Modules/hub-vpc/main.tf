# ======================================================================
# Hub VPC Module — main.tf
# ======================================================================
# Creates a VPC with multiple subnets, Cloud NAT, and VPC flow logs.
# Used by the Networks stage (Stage 3).
# ======================================================================

# ----------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------
resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# ----------------------------------------------------------------------
# SUBNETS
# ----------------------------------------------------------------------
resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnets

  name          = "${var.vpc_name}-${each.key}"
  project       = var.project_id
  network       = google_compute_network.vpc.id
  region        = each.value.region
  ip_cidr_range = each.value.cidr

  private_ip_google_access = each.value.private_google_access

  dynamic "log_config" {
    for_each = var.enable_flow_logs ? [1] : []
    content {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

# ----------------------------------------------------------------------
# CLOUD ROUTER + CLOUD NAT
# ----------------------------------------------------------------------
# One Cloud Router per unique region (subnets may share regions).
# NAT is created for each region that has subnets.

locals {
  regions = distinct([for s in var.subnets : s.region])
}

resource "google_compute_router" "router" {
  for_each = var.nat_enabled ? toset(local.regions) : []

  name    = "${var.vpc_name}-router-${each.key}"
  project = var.project_id
  network = google_compute_network.vpc.id
  region  = each.key
}

resource "google_compute_router_nat" "nat" {
  for_each = var.nat_enabled ? toset(local.regions) : []

  name   = "${var.vpc_name}-nat-${each.key}"
  router = google_compute_router.router[each.key].name
  region = each.key
  project = var.project_id

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

