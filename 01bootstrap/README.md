# Bootstrap Stage — Terraform State & CI/CD Foundation

This is the **first stage** you must run. It creates the foundational infrastructure that all other stages depend on.

## What it builds

| Resource | Name | Purpose |
|----------|------|---------|
| **Project** | `bootstrap-infra-state` | Holds the Terraform state bucket + service accounts |
| **GCS Bucket** | `terraform-state-asliadarsh-XXXX` | Stores `.tfstate` files for ALL stages (versioned & locked) |
| **Service Accounts** | `terraform-org` | Used by the Organization stage |
| | `terraform-networks` | Used by the Networks stage |
| | `terraform-service-projects` | Used by the Service Projects stage |
| **Project** | `bootstrap-cicd` | Holds Workload Identity Federation for GitHub Actions |
| **WIF Pool** | `github-actions-pool` | Identity pool for GitHub Actions |
| **WIF Provider** | `github-actions-oidc` | OIDC provider linked to your GitHub repo |

## Prerequisites

Before running, your service account needs these **org-level** roles:

```
roles/resourcemanager.folderAdmin
roles/resourcemanager.projectCreator
roles/resourcemanager.projectIamAdmin
roles/billing.user
```

## How to run

```bash
# 1. Authenticate with your service account
gcloud auth activate-service-account --key-file=path/to/your-key.json
gcloud config set project bootstrap-infra-state

# 2. Fill in your values
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your org_id, billing_account, bucket name

# 3. Initialize (local state — bucket doesn't exist yet)
cd 01bootstrap
terraform init

# 4. Review and apply
terraform plan
terraform apply

# 5. Migrate state to the new GCS bucket
terraform init -migrate-state
```

## What comes next

Once bootstrap completes, copy these outputs for the next stage:

- `state_bucket_name` — needed in every downstream `backend.tf`
- `terraform_org_sa_email` — used by Organization stage
- `workload_identity_provider_name` — needed for GitHub Actions setup
