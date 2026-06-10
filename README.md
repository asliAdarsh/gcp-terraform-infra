# GCP Terraform Infrastructure

Enterprise-grade GCP infrastructure managed with Terraform, based on Google's [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation).

## Architecture

```
 Bootstrap  →  Organization  →  Networks  →  Core/Spoke
    (1)            (2)             (3)          (4)
```

4 base stages bootstrap the foundation; stage 4 uses a **Core/Spoke** pattern — Core manages team folders under each environment, and Spoke gives each team autonomous control over their resources.

## Repository Structure

```
gcp-terraform-infra/
├── 01bootstrap/             # Stage 1: State bucket + SAs + WIF
├── 02organization/          # Stage 2: Folders + host project + IAM
├── 03networks/              # Stage 3: VPC + subnets + NAT + firewall
├── Modules/                 # Reusable modules (service-project, compute-vm, cloud-sql, storage-bucket)
├── Deployment/              # tfvars configs
│   ├── Core/                #   Core/dev.tfvars -> team list
│   └── Spoke/{Team}/       #   Per-team env config (dev, prod)
├── Workload/                # Terraform code
│   ├── Core/                #   Team folder creation
│   └── Spoke/{Team}/       #   Team resources (any GCP service)
└── .github/workflows/       # CI/CD per team + core + PR checks
```

## Quick Start

```bash
# Bootstrap state bucket and service accounts
cd 01bootstrap && terraform init && terraform apply

# Deploy Core (team folders)
cd ../Workload/Core && terraform init -backend-config="bucket=YOUR_STATE_BUCKET"
terraform apply -var-file=../../Deployment/Core/dev.tfvars

# Deploy a Spoke team's resources
cd ../Spoke/{Team} && terraform init -backend-config="bucket=YOUR_STATE_BUCKET"
terraform apply -var-file=../../../Deployment/Spoke/{Team}/dev.tfvars
```

## Adding a Team

1. Add the team name to `Deployment/Core/dev.tfvars`.
2. Create `Deployment/Spoke/{Team}/dev.tfvars` with project config (use placeholders — never commit real IDs).
3. Create `Workload/Spoke/{Team}/main.tf` referencing any Module or custom resource.
4. Create `.github/workflows/{team}.yaml` triggering on the team's path.
5. Open one PR. Review. Merge. Everything provisions automatically.

## CI/CD

| Workflow | Trigger | Action |
|----------|---------|--------|
| `core.yaml` | Push to dev/staging/prod | Deploys Core team folders |
| `{team}.yaml` | Push to dev/staging/prod | Deploys team project + resources |
| `pr-check.yaml` | PR | Format check + module validation |

**Required GitHub secrets:** `WIF_PROVIDER`, `WIF_SERVICE_ACCOUNT`, `TF_STATE_BUCKET`.

---

📜 **License**

This project is licensed under the MIT License — see the [LICENSE](../LICENSE) file for details.
