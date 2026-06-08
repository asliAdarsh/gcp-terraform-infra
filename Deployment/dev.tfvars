# ======================================================================
# Development Environment Configuration
# ======================================================================
#
# Usage: terraform apply -var-file=../Deployment/dev.tfvars
#
# ======================================================================

environment = "dev"

organization_id    = "310558825488"
billing_account_id = "019ED6-BEBD8C-EA1EB9"

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
