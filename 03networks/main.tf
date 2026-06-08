# ======================================================================
# Networks Stage — main.tf
# ======================================================================
#
# Purpose: Create the Shared VPC with multi-environment subnets,
# Cloud NAT, firewall rules, and DNS zones.
#
# This is Stage 3 of 4. Must run AFTER bootstrap and organization.
#
# ======================================================================

# ----------------------------------------------------------------------
# Remote State: Read outputs from Organization stage
# ----------------------------------------------------------------------
data "terraform_remote_state" "organization" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket_name
    prefix = "organization"
  }
}

locals {
  host_project_id = data.terraform_remote_state.organization.outputs.host_project_id
}

# ----------------------------------------------------------------------
# HUB VPC
# ----------------------------------------------------------------------
module "hub_vpc" {
  source = "../Modules/hub-vpc"

  project_id = local.host_project_id
  vpc_name   = "vpc-shared"

  subnets = {
    dev = {
      region = "asia-south1"
      cidr   = "10.0.1.0/24"
    }
    staging = {
      region = "asia-south1"
      cidr   = "10.0.2.0/24"
    }
    prod = {
      region = "asia-south1"
      cidr   = "10.0.3.0/24"
    }
  }

  enable_flow_logs = true
  nat_enabled      = true
}

# ----------------------------------------------------------------------
# FIREWALL RULES
# ----------------------------------------------------------------------
module "firewall" {
  source = "../Modules/firewall"

  project_id = local.host_project_id
  vpc_name   = module.hub_vpc.vpc_name

  rules = {
    # Allow IAP TCP forwarding (SSH)
    allow-iap-ssh = {
      description   = "Allow IAP tunnel for SSH access to VMs"
      priority      = 65534
      source_ranges = ["35.235.240.0/20"]
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
    }

    # Allow IAP RDP forwarding
    allow-iap-rdp = {
      description   = "Allow IAP tunnel for RDP access to VMs"
      priority      = 65534
      source_ranges = ["35.235.240.0/20"]
      allow = [{
        protocol = "tcp"
        ports    = ["3389"]
      }]
    }

    # Allow health check probes
    allow-health-checks = {
      description   = "Allow GCP health check probes"
      priority      = 65534
      source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
      allow = [{
        protocol = "tcp"
      }]
    }

    # Allow internal traffic between environments
    allow-internal = {
      description   = "Allow internal traffic within the VPC"
      priority      = 65534
      source_ranges = ["10.0.0.0/8"]
      allow = [
        { protocol = "tcp" },
        { protocol = "udp" },
        { protocol = "icmp" },
      ]
    }

    # Deny all other ingress (default)
    deny-all-ingress = {
      description   = "Default deny all ingress traffic"
      priority      = 65535
      source_ranges = ["0.0.0.0/0"]
      deny = [{
        protocol = "all"
      }]
    }
  }
}

# ----------------------------------------------------------------------
# DNS PRIVATE ZONES
# ----------------------------------------------------------------------
# Private DNS zone for internal resolution within the VPC.

resource "google_dns_managed_zone" "internal" {
  name        = "internal-zone"
  dns_name    = "internal."
  description = "Private DNS zone for internal VPC resolution"
  project     = local.host_project_id
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = module.hub_vpc.vpc_id
    }
  }
}

# ----------------------------------------------------------------------
# OUTPUT AGGREGATION
# ----------------------------------------------------------------------
# Collect module outputs for consumption by Stage 4 (Service Projects).
