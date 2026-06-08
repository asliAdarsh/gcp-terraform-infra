# ======================================================================
# Compute VM Module — Outputs
# ======================================================================

output "vm_name" {
  description = "Name of the created VM"
  value       = google_compute_instance.vm.name
}

output "vm_id" {
  description = "ID of the created VM"
  value       = google_compute_instance.vm.id
}

output "zone" {
  description = "Zone where the VM was created"
  value       = google_compute_instance.vm.zone
}

output "internal_ip" {
  description = "Internal IP address of the VM"
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "external_ip" {
  description = "External IP address of the VM (null if assign_public_ip was false)"
  value       = var.assign_public_ip ? google_compute_address.vm_public_ip[0].address : null
}

output "self_link" {
  description = "Self-link of the VM"
  value       = google_compute_instance.vm.self_link
}
