# Documentation Index

Concise reference docs for the GCP Terraform infrastructure repository.

## 01 — Architecture

| File | What it covers |
|------|----------------|
| [01-overview.md](01-architecture/01-overview.md) | High-level architecture: 4 bootstrap stages + Core/Spoke for teams |
| [02-repo-structure.md](01-architecture/02-repo-structure.md) | Every folder in the repo explained |
| [03-core-spoke-pattern.md](01-architecture/03-core-spoke-pattern.md) | How Core manages team folders and Spoke gives teams autonomy |

## 02 — Setup

| File | What it covers |
|------|----------------|
| [01-prerequisites.md](02-setup/01-prerequisites.md) | Required IAM roles, tools, and permissions |
| [02-bootstrap.md](02-setup/02-bootstrap.md) | Stage 1: State bucket, service accounts, Workload Identity Federation |
| [03-organization.md](02-setup/03-organization.md) | Stage 2: Folders, host project, IAM, org policies |

## 03 — Networks

| File | What it covers |
|------|----------------|
| [01-vpc-and-subnets.md](03-networks/01-vpc-and-subnets.md) | VPC and subnet design |
| [02-firewall-and-nat.md](03-networks/02-firewall-and-nat.md) | NAT gateway, firewall rules, DNS |

## 04 — Teams

| File | What it covers |
|------|----------------|
| [01-onboarding.md](04-teams/01-onboarding.md) | How a new team gets started |
| [02-creating-projects.md](04-teams/02-creating-projects.md) | Spoke apps and the service-project module |
| [03-custom-resources.md](04-teams/03-custom-resources.md) | Adding GKE, Cloud SQL, etc. in main.tf |

## 05 — CI/CD

| File | What it covers |
|------|----------------|
| [01-pipeline-overview.md](05-ci-cd/01-pipeline-overview.md) | How GitHub Actions workflows work |
| [02-per-team-pipelines.md](05-ci-cd/02-per-team-pipelines.md) | Per-team workflow pattern and PR checks |

## 06 — Operations

| File | What it covers |
|------|----------------|
| [01-common-commands.md](06-operations/01-common-commands.md) | Daily commands reference |
| [02-troubleshooting.md](06-operations/02-troubleshooting.md) | Common errors and fixes |
