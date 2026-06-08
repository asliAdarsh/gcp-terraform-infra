# ======================================================================
# Compute VM Module — Variables
# ======================================================================
# Creates a simple Linux VM with IAP SSH access and no public IP.
# ======================================================================

variable "project_id" {
  description = "Project ID where the VM will be created"
  type        = string
}

variable "vm_name" {
  description = "Name of the VM instance"
  type        = string
}

variable "zone" {
  description = "GCP zone (e.g. asia-south1-a)"
  type        = string
  default     = "asia-south1-a"
}

variable "machine_type" {
  description = "Machine type (e.g. e2-micro, e2-small)"
  type        = string
  default     = "e2-micro"
}

variable "subnet_self_link" {
  description = "Self-link of the subnet to attach the VM to"
  type        = string
}

variable "tags" {
  description = "Network tags for firewall rule matching"
  type        = list(string)
  default     = ["iap-ssh"]
}

variable "image" {
  description = "Boot disk image (family or family/version)"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

variable "assign_public_ip" {
  description = "If true, assign an ephemeral public IP. For use without IAP."
  type        = bool
  default     = false
}
