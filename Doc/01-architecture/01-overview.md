# Architecture Overview

This repo manages enterprise GCP infrastructure using a staged Terraform approach based on Google's [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation).

## The 4 Bootstrap Stages

Infrastructure is provisioned in a strict order. Each stage creates the foundations the next one depends on.

```
 01 Bootstrap  -->  02 Organization  -->  03 Networks  -->  04 Core/Spoke
 (state + SAs)     (folders + IAM)       (VPC + NAT)      (team projects)
```

**Stage 1 — Bootstrap** (`01bootstrap/`)
Creates the GCS bucket for remote Terraform state, per-stage service accounts, and Workload Identity Federation so GitHub Actions can authenticate without static keys. Run this once manually.

**Stage 2 — Organization** (`02organization/`)
Creates environment folders (dev, staging, prod), a Shared VPC host project, sets org-level IAM policies, and enables required APIs.

**Stage 3 — Networks** (`03networks/`)
Deploys the Hub VPC with subnets, Cloud NAT, firewall rules, and DNS configuration.

**Stage 4 — Core/Spoke** (`Workload/Core` + `Workload/Spoke/`)
Not a single stage but two layers that run continuously: Core creates team sub-folders, and each Spoke team defines the actual GCP resources they need.

## Environment Folders

```
Organization
  └── f-dev
  │     ├── Team-Clynz
  │     └── Team-Totes
  ├── f-staging
  │     ├── Team-Clynz
  │     └── Team-Totes
  └── f-prod
        ├── Team-Clynz
        └── Team-Totes
```

Each environment has its own `.tfvars` file targeting that folder. Teams are isolated to their own sub-folder under each environment.

## Key Principles

- **Immutable state** in GCS with versioning and lifecycle rules
- **No static keys** — all CI/CD uses Workload Identity Federation
- **Least privilege** — each stage gets its own service account
- **PR-driven changes** — every change goes through a PR with `terraform plan`
