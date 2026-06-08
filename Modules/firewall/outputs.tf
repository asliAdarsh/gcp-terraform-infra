# ======================================================================
# Firewall Module — Outputs
# ======================================================================

output "firewall_rule_names" {
  description = "List of created firewall rule names"
  value       = keys(google_compute_firewall.rules)
}
