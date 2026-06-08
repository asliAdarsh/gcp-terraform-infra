# ======================================================================
# Networks Stage — Outputs
# ======================================================================
#
# These values are consumed by Stage 4 (Service Projects).
#
# ======================================================================

output "vpc_name" {
  description = "Name of the shared VPC"
  value       = module.hub_vpc.vpc_name
}

output "vpc_self_link" {
  description = "Self-link of the VPC (for service project attachment)"
  value       = module.hub_vpc.vpc_self_link
}

output "subnet_names" {
  description = "Map of subnet names keyed by environment"
  value       = module.hub_vpc.subnet_names
}

output "subnet_self_links" {
  description = "Map of subnet self-links keyed by environment (for subnet-level IAM)"
  value       = module.hub_vpc.subnet_self_links
}

output "host_project_id" {
  description = "Project ID of the host project (passed through from organization)"
  value       = local.host_project_id
}

output "firewall_rule_names" {
  description = "List of created firewall rule names"
  value       = module.firewall.firewall_rule_names
}
