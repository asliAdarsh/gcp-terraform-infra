# Totes Team — Development

team_name          = "Totes"
project_component  = "backend"
project_id         = "totes-backend-dev"
environment        = "dev"

apis      = ["compute.googleapis.com"]
create_vm   = true
create_sql  = false
create_bucket = false

vm_machine_type = "e2-micro"
vm_image        = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"

# First Totes project with VM
