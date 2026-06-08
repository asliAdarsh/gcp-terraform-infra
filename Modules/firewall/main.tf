# ======================================================================
# Firewall Module — main.tf
# ======================================================================
# Creates VPC firewall rules from a reusable map of rule definitions.
# Used by the Networks stage.
# ======================================================================

resource "google_compute_firewall" "rules" {
  for_each = var.rules

  name        = each.key
  project     = var.project_id
  network     = var.vpc_name
  direction   = each.value.direction
  priority    = each.value.priority
  description = each.value.description

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
}
