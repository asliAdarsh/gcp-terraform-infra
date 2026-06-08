# GCP Terraform Infrastructure

A simplified enterprise-grade GCP infrastructure setup using Terraform, based on Google's [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation) patterns.

## Architecture

```
Bootstrap  →  Organization  →  Networks  →  Service Projects
   (1)            (2)             (3)              (4)
```

Each stage produces outputs consumed by the next. Stages must run sequentially.

## Stages

| Stage | Directory | What it creates |
|-------|-----------|-----------------|
| 1. Bootstrap | `01bootstrap/` | GCS state bucket, service accounts, WIF for GitHub Actions |
| 2. Organization | `02organization/` | Folders (f-platform, f-dev, f-staging, f-prod), host project, org policies |
| 3. Networks | `03networks/` | Shared VPC, subnets, Cloud NAT, firewall rules, DNS |
| 4. Service Projects | `04service-projects/` | Environment projects, Shared VPC attachment |

## Prerequisites

### IAM Permissions Required

Your service account needs these roles before running the bootstrap stage:

**Organization-level roles** (granted by Org Admin):
| Role | Purpose |
|------|---------|
| `roles/resourcemanager.folderAdmin` | Create and manage folders |
| `roles/resourcemanager.projectCreator` | Create projects |
| `roles/resourcemanager.projectIamAdmin` | Assign IAM on projects |
| `roles/billing.user` | Link billing accounts to projects |
| `roles/iam.workloadIdentityPoolAdmin` | Create WIF pools for GitHub Actions |

> **Note:** `iam.workloadIdentityPoolAdmin` was added after the initial setup — if you hit a permission error during bootstrap, ask your Org Admin to grant this role.

**To grant all roles at once:**
```bash
gcloud organizations add-iam-policy-binding <ORG_ID> \
  --member="serviceAccount:YOUR_SA@PROJECT.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.folderAdmin"

gcloud organizations add-iam-policy-binding <ORG_ID> \
  --member="serviceAccount:YOUR_SA@PROJECT.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectCreator"

gcloud organizations add-iam-policy-binding <ORG_ID> \
  --member="serviceAccount:YOUR_SA@PROJECT.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectIamAdmin"

gcloud organizations add-iam-policy-binding <ORG_ID> \
  --member="serviceAccount:YOUR_SA@PROJECT.iam.gserviceaccount.com" \
  --role="roles/billing.user"

gcloud organizations add-iam-policy-binding <ORG_ID> \
  --member="serviceAccount:YOUR_SA@PROJECT.iam.gserviceaccount.com" \
  --role="roles/iam.workloadIdentityPoolAdmin"
```

### Values to collect

| Value | How to get it |
|-------|--------------|
| Organization ID | `gcloud organizations list` |
| Billing Account ID | `gcloud billing accounts list` |
| Service Account Key | From your existing SA JSON key file |

## Getting Started

```bash
# 1. Authenticate
gcloud auth activate-service-account --key-file=path/to/key.json

# 2. Run bootstrap (Stage 1)
cd 01bootstrap
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
terraform init -migrate-state

# 3. Run organization (Stage 2)
cd ../02organization
cp terraform.tfvars.example terraform.tfvars
terraform init -backend-config="bucket=YOUR_BUCKET_NAME"
terraform plan
terraform apply
```

## Useful Docs

- [Common Mistakes & Troubleshooting](Doc/common-mistakes.md) — Solutions for errors encountered in each stage
- [gcp-terraform-infra-plan](https://github.com/asliAdarsh/gcp-terraform-infra) — Detailed architecture docs in Obsidian vault
