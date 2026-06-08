# Service Projects Stage — Environment Projects & Shared VPC

Creates service projects under environment folders, each attached to the shared VPC.

## How this stage works

Unlike previous stages which run once, this stage runs **once per environment** with a different `.tfvars` file:

```bash
# Create dev projects
terraform apply -var-file=../Deployment/dev.tfvars

# Create staging projects
terraform apply -var-file=../Deployment/staging.tfvars

# Create prod projects
terraform apply -var-file=../Deployment/prod.tfvars
```

Each environment gets its own state file under the `service-projects/` prefix.

## What it builds

| Resource | Example Name | Purpose |
|----------|-------------|---------|
| Project | `sb-dev-backend-api` | Dev backend project under f-dev folder |
| APIs | compute, container, etc. | Enabled on each project |
| Shared VPC | Attached to host | Service project can use `vpc-shared` subnets |

## Prerequisites

All 3 previous stages must be complete. You need:
- `state_bucket_name` from bootstrap
- `env_folder_ids` from organization (auto-read from remote state)
- `subnet_self_links` from networks (auto-read from remote state)

## How to run (e.g., dev)

```bash
cd 04service-projects
terraform init -backend-config="bucket=terraform-state-asliadarsh-18792"
terraform plan -var-file=../Deployment/dev.tfvars
terraform apply -var-file=../Deployment/dev.tfvars
```

Repeat for staging and prod.
