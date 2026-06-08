# ======================================================================
# Common Configuration — shared across all teams and environments
# ======================================================================
# Include this file first in every terraform plan/apply command:
#
#   terraform plan -var-file=../../Deployment/common.tfvars \
#                  -var-file=../../Deployment/Spore/<team>/<env>.tfvars
#
# ======================================================================

organization_id    = "310558825488"
billing_account_id = "019ED6-BEBD8C-EA1EB9"
state_bucket_name  = "terraform-state-asliadarsh-18792"
region             = "asia-south1"
