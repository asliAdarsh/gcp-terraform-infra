# GCP Terraform Infrastructure

A simplified enterprise-grade GCP infrastructure setup using Terraform, based on Google's [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation) patterns.

## Architecture

```
Bootstrap  →  Organization  →  Networks  →  Core  →  Spoke Apps
   (1)            (2)             (3)       (4)         (5)
```

## Repository Structure

```
├── 01bootstrap/                       # Stage 1: State bucket + SAs + WIF
├── 02organization/                    # Stage 2: Folders + host project + IAM
├── 03networks/                        # Stage 3: VPC + subnets + NAT + firewall
│
├── Deployment/                        # Environment config (tfvars ONLY)
│   ├── Core/
│   │   └── dev.tfvars                 → List of teams (e.g. ["Clynz"])
│   └── Spoke/
│       └── Clynz/
│           ├── dev.tfvars             → clynz-backend-dev project + VM
│           └── prod.tfvars            → clynz-backend-prod + VM + SQL
│
├── Workload/                          # Terraform code (main.tf ONLY)
│   ├── Core/
│   │   ├── main.tf                    → Creates team folders under f-dev/prod
│   │   └── providers.tf
│   └── Spoke/
│       └── Clynz/
│           ├── main.tf                → Module call + custom resources
│           └── providers.tf
│
├── Modules/                           # Reusable terraform modules
│   ├── service-project/               → Project + APIs + VPC attachment
│   ├── compute-vm/                    → VM instance
│   ├── cloud-sql/                     → PostgreSQL instance
│   └── storage-bucket/                → GCS bucket
│
└── .github/workflows/
    ├── deploy-app.yaml                # Reusable CI/CD pipeline
    ├── core.yaml                      # Team folder deployment
    ├── clynz.yaml                     # Clynz team app deployment
    ├── pr-check.yaml                  # PR validation
    └── {team}.yaml                    # One per team
```

## The Core/Spoke Pattern

### Core
Creates team sub-folders under each environment folder:
```
f-dev → Clynz → clynz-backend-dev + VM
f-prod → Clynz → clynz-backend-prod + SQL + bucket
```

### Spoke
Each team has their own folder where they control **what** gets deployed:

- `Deployment/Spoke/{Team}/dev.tfvars` → Config (project ID, APIs, flags)
- `Workload/Spoke/{Team}/main.tf` → Terraform code with full flexibility

Teams can add ANY GCP resource in their `main.tf` — GKE clusters, Cloud Run services, VMs, databases — without waiting for the platform team.

## How to Add a New Team

### 1. Register in Core
**`Deployment/Core/dev.tfvars`** — add team name:
```hcl
teams = ["Clynz", "Totes"]
```

### 2. Create Deployment config
**`Deployment/Spoke/Totes/dev.tfvars`**:
```hcl
team_name          = "Totes"
project_component  = "backend"
project_id         = "totes-backend-dev"
environment        = "dev"
billing_account_id = "019ED6-BEBD8C-EA1EB9"
state_bucket_name  = "terraform-state-asliadarsh-18792"
region             = "asia-south1"
apis               = ["compute.googleapis.com"]
create_vm          = true
```

### 3. Create Workload code
Copy `Workload/Spoke/Clynz/` to `Workload/Spoke/Totes/`. Edit `main.tf` to add custom resources (GKE, Cloud SQL, etc.)

### 4. Create pipeline
Create `.github/workflows/totes.yaml`:
```yaml
name: Deploy Totes
on:
  push:
    branches: [dev, staging, prod]
    paths: ['Deployment/Spoke/Totes/**', 'Workload/Spoke/Totes/**', 'Modules/**']
jobs:
  deploy:
    uses: ./.github/workflows/deploy-app.yaml
    with:
      workload-path: Spoke/Totes
      environment: ${{ github.ref_name }}
    secrets: inherit
```

### 5. One PR. One review. Everything created.

## Prerequisites

Your service account needs these org-level roles:
```
roles/resourcemanager.folderAdmin
roles/resourcemanager.projectCreator
roles/resourcemanager.projectIamAdmin
roles/billing.user
roles/iam.workloadIdentityPoolAdmin
```

## CI/CD Pipeline

| Workflow | Trigger | What it does |
|----------|---------|-------------|
| `core.yaml` | Push to dev/staging/prod | Deploys team folders |
| `{team}.yaml` | Push to dev/staging/prod | Deploys team's project + resources |
| `pr-check.yaml` | PR to dev/staging/prod | Format check + validate changed modules |
| `deploy-app.yaml` | Called by workflows | Shared init → plan → apply steps |

### GitHub Secrets Required

| Secret | Value |
|--------|-------|
| `WIF_PROVIDER` | From bootstrap output |
| `WIF_SERVICE_ACCOUNT` | From bootstrap output |
| `TF_STATE_BUCKET` | From bootstrap output |

## Getting Started

```bash
# Authenticate
gcloud auth activate-service-account --key-file=path/to/key.json

# Deploy team folders (Core)
cd Workload/Core
terraform init -backend-config="bucket=terraform-state-asliadarsh-18792"
terraform plan -var-file=../../Deployment/Core/dev.tfvars
terraform apply -var-file=../../Deployment/Core/dev.tfvars

# Deploy app (Spoke)
cd ../Spoke/Clynz
terraform init -backend-config="bucket=terraform-state-asliadarsh-18792"
terraform plan -var-file=../../../Deployment/Spoke/Clynz/dev.tfvars
terraform apply -var-file=../../../Deployment/Spoke/Clynz/dev.tfvars
```
