# Clynz Team — Development

team_name          = "Clynz"
project_component  = "backend"
project_id         = "clynz-backend-dev"
environment        = "dev"
billing_account_id = "019ED6-BEBD8C-EA1EB9"
state_bucket_name  = "terraform-state-asliadarsh-18792"
region             = "asia-south1"

apis      = ["compute.googleapis.com"]
create_vm   = true
create_sql  = false
create_bucket = false

vm_machine_type = "e2-micro"
vm_image        = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
