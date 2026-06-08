# Clynz Team — Production

team_name          = "Clynz"
project_component  = "backend"
project_id         = "clynz-backend-prod"
environment        = "prod"
billing_account_id = "019ED6-BEBD8C-EA1EB9"
state_bucket_name  = "terraform-state-asliadarsh-18792"
region             = "asia-south1"

apis      = ["compute.googleapis.com", "container.googleapis.com"]
create_vm   = true
create_sql  = true
create_bucket = true

vm_machine_type = "e2-small"
vm_image        = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
