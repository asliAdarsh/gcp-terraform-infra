# Organization Stage — Folders, Host Project, IAM & Policies

This stage creates the GCP resource hierarchy containers and the Shared VPC host project.

## What it builds

| Resource | Name | Purpose |
|----------|------|---------|
| **Folder** | `f-platform` | Hosts the Shared VPC host project |
| **Folder** | `f-dev` | Hosts dev service projects |
| **Folder** | `f-staging` | Hosts staging service projects |
| **Folder** | `f-prod` | Hosts prod service projects |
| **Project** | `host-platform` | The Shared VPC host project (VPC lives here) |
| **IAM** | Org & folder level | Grants org admin, network admin, and environment team roles |
| **Org Policies** | Various | Restricts external IPs, enforces domain, requires Shielded VM |

## Prerequisites

Bootstrap stage must be complete. You need:
- `state_bucket_name` from bootstrap outputs
- `terraform_org_sa_email` from bootstrap outputs

## How to run

```bash
# 1. Copy and fill terraform.tfvars
cd 02organization
cp terraform.tfvars.example terraform.tfvars
# Edit with your IDs

# 2. Initialize (uses GCS backend from bootstrap)
terraform init

# 3. Review and apply
terraform plan
terraform apply
```

## Outputs used by later stages

- `platform_folder_id` → Networks stage
- `env_folder_ids` → Service Projects stage
- `host_project_id` → Networks stage
