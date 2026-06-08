# ----------------------------------------------------------------------
# Firewall Module — Variables
# ----------------------------------------------------------------------

variable "project_id" {
  description = "Project ID where firewall rules will be created"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC to apply firewall rules to"
  type        = string
}

variable "rules" {
  description = <<-EOT
    Map of firewall rules to create.
    Each entry: { direction, priority, source_ranges, allow, deny, target_tags }
    allow and deny are lists of { protocol, ports } objects.
  EOT
  type = map(object({
    direction     = optional(string, "INGRESS")
    priority      = optional(number, 1000)
    source_ranges = optional(list(string), ["0.0.0.0/0"])
    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    target_tags = optional(list(string), [])
    description = optional(string, "")
  }))
}
