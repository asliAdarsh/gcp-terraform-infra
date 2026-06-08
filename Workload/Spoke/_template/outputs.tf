# ======================================================================
# {TEAM} App — Outputs — TEMPLATE
# ======================================================================

output "project_id"        { value = module.project.project_id }
output "project_number"    { value = module.project.project_number }
output "vm_internal_ip"    { value = module.project.vm_internal_ip }
output "vm_external_ip"    { value = module.project.vm_external_ip }
output "bucket_name"       { value = module.project.bucket_name }
