# ----------------------------------------------------------------------
# Organization Stage — Provider Configuration
# ----------------------------------------------------------------------
#
# This stage runs using your locally authenticated service account
# (the same one used for bootstrap). The SA already has the required
# org-level roles: folderAdmin, projectCreator, projectIamAdmin, etc.
#
# In CI/CD, this stage would impersonate the terraform-org SA via WIF.

provider "google" {
  region = var.region
}
