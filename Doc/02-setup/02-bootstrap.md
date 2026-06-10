# Stage 1: Bootstrap

**Folder:** `01bootstrap/`

Creates the foundational GCP resources that every later stage depends on. Run this once manually from your local machine.

## What Gets Created

### 1. State Project (`bootstrap-infra-state`)

A GCP project that holds:
- **GCS bucket** for Terraform remote state — one bucket, all stages use it with different prefixes (`terraform/organization`, `terraform/networks`, etc.)
- **Per-stage service accounts** — one SA per downstream stage (`terraform-org`, `terraform-networks`, `terraform-service-projects`) with only the permissions they need

### 2. CICD Project (`bootstrap-cicd-18792`)

A separate GCP project that holds:
- **Workload Identity Pool + Provider** — a secure bridge between GitHub Actions and GCP
- **IAM bindings** — each stage SA can be impersonated by the WIF pool

### 3. Key IAM Bindings

```
WIF Pool  --impersonates-->  Stage SAs  --accesses-->  State Bucket
```

GitHub Actions presents an OIDC token, GCP verifies it, and the workflow can act as the correct service account. No static keys are stored in GitHub Secrets.

## How to Run

```bash
cd 01bootstrap
terraform init
terraform apply
```

After apply completes, note the bucket name and service account emails — you'll need them for later stages and GitHub Secrets.

## What You Get

| Output | Description |
|--------|-------------|
| State bucket | GCS bucket name (set via `var.state_bucket_name`) |
| Stage SAs | `terraform-org`, `terraform-networks`, `terraform-service-projects` |
| WIF provider | Resource name for GitHub Actions authentication |

## Common Pitfalls

- See `common-mistakes.md` for project name length limits (30 chars), `billing_account_id` vs `billing_account` attribute naming, and project ID conflicts.
