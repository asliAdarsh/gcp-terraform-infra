# ======================================================================
# Staging Environment Configuration
# ======================================================================
#
# Usage: terraform apply -var-file=../Deployment/staging.tfvars
#
# ======================================================================

environment = "staging"

region = "asia-south1"

state_bucket_name = "terraform-state-asliadarsh-18792"

service_projects = [
  {
    name        = "backend-api"
    apis        = ["compute.googleapis.com", "container.googleapis.com"]
    create_vm   = false
    create_sql  = true
    create_bucket = true
  },
  {
    name        = "frontend-web"
    apis        = ["compute.googleapis.com", "run.googleapis.com"]
    create_vm   = false
    create_sql  = false
    create_bucket = true
  },
]
