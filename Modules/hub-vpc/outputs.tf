# ======================================================================
# Hub VPC Module — Outputs
# ======================================================================

output "vpc_name" {
  description = "Name of the created VPC"
  value       = google_compute_network.vpc.name
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = google_compute_network.vpc.id
}

output "vpc_self_link" {
  description = "Self-link of the VPC (used for attaching service projects)"
  value       = google_compute_network.vpc.self_link
}

output "subnet_names" {
  description = "Map of subnet names keyed by environment"
  value = {
    for k, subnet in google_compute_subnetwork.subnet : k => subnet.name
  }
}

output "subnet_self_links" {
  description = "Map of subnet self-links keyed by environment (used for subnet-level IAM)"
  value = {
    for k, subnet in google_compute_subnetwork.subnet : k => subnet.self_link
  }
}

output "subnet_regions" {
  description = "Map of subnet regions keyed by environment"
  value = {
    for k, subnet in google_compute_subnetwork.subnet : k => subnet.region
  }
}

output "nat_region_cloud_routers" {
  description = "Map of Cloud Router names keyed by region"
  value = var.nat_enabled ? {
    for k, router in google_compute_router.router : k => router.name
  } : {}
}
