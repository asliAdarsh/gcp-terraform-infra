# ======================================================================
# Development Environment Configuration
# ======================================================================
#
# Usage: terraform apply -var-file=../Deployment/dev.tfvars
#
# ======================================================================

environment = "dev"

region = "asia-south1"

state_bucket_name = "terraform-state-asliadarsh-18792"

service_projects = [
  {
    name        = "backend-api"
    apis        = ["compute.googleapis.com"]
    create_vm   = true
    create_sql  = false
    create_bucket = false
  },
]
