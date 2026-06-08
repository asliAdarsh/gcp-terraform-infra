# ----------------------------------------------------------------------
# Hub VPC Module — Variables
# ----------------------------------------------------------------------

variable "project_id" {
  description = "Project ID where the VPC will be created (host project)"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC (e.g. vpc-shared)"
  type        = string
  default     = "vpc-shared"
}

variable "subnets" {
  description = <<-EOT
    Map of subnets to create.
    Each entry: { region, cidr, private_google_access (optional) }
    Key is used as subnet name suffix.
  EOT
  type = map(object({
    region               = string
    cidr                 = string
    private_google_access = optional(bool, true)
  }))
}

variable "enable_flow_logs" {
  description = "Enable VPC flow logs on all subnets"
  type        = bool
  default     = true
}

variable "nat_enabled" {
  description = "Enable Cloud NAT for each subnet region"
  type        = bool
  default     = true
}
