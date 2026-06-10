# Repository Structure

```
gcp-terraform-infra/
├── 01bootstrap/              # Stage 1: state bucket, SAs, WIF
├── 02organization/           # Stage 2: folders, host project, IAM
├── 03networks/               # Stage 3: VPC, subnets, NAT, firewall
├── Modules/                  # Reusable Terraform modules
│   ├── service-project/      #   Creates a project + Shared VPC attachment
│   ├── compute-vm/           #   VM instance with IAP SSH
│   ├── cloud-sql/            #   Cloud SQL (PostgreSQL) instance
│   ├── storage-bucket/       #   GCS bucket with uniform access
│   ├── hub-vpc/              #   Hub VPC with subnets
│   └── firewall/             #   Firewall rules
├── Deployment/               # tfvars per environment
│   ├── Core/                 #   Core/dev.tfvars — list of team names
│   └── Spoke/{Team}/         #   Per-team, per-env configs
├── Workload/                 # Terraform root modules
│   ├── Core/                 #   Creates team folders under env folders
│   └── Spoke/                #   Per-team resource stacks
│       ├── _template/        #   Copy this to start a new team
│       ├── Clynz/
│       └── Totes/
├── .github/workflows/        # CI/CD pipelines
│   ├── core.yaml             #   Deploys Core team folders
│   ├── clynz.yaml            #   Clynz team pipeline
│   ├── totes.yaml            #   Totes team pipeline
│   ├── _template.yaml        #   Copy this for new teams
│   ├── deploy-app.yaml       #   Reusable deploy workflow
│   └── pr-check.yaml         #   Format + validate on PRs
└── Doc/                      # You are here
    └── common-mistakes.md    # Known errors and fixes
```

## What Goes Where

| Folder | Purpose |
|--------|---------|
| `01bootstrap/` | Run once manually. Creates shared resources. |
| `02organization/` | Run once per org. Sets up folder hierarchy. |
| `03networks/` | Run once per org. Deploys base networking. |
| `Modules/` | Shared terraform modules consumed by Spoke teams. |
| `Deployment/` | `.tfvars` files — teams edit these to configure their projects. |
| `Workload/Core/` | Terraform root module for team folder creation. |
| `Workload/Spoke/{Team}/` | Each team's infrastructure lives here. |
