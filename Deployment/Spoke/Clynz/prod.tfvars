# Clynz Team — Production
# Usage: terraform apply -var-file=../../../Deployment/common.tfvars -var-file=prod.tfvars

team_name          = "Clynz"
project_component  = "backend"
project_id         = "clynz-backend-prod"
environment        = "prod"

apis      = ["compute.googleapis.com", "container.googleapis.com"]
create_vm   = true
create_sql  = true
create_bucket = true

vm_machine_type = "e2-small"
vm_image        = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
