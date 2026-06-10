# Prerequisites

Before running any Terraform, ensure you have the following.

## Tools

| Tool | Minimum Version | Why |
|------|----------------|-----|
| [Terraform](https://developer.hashicorp.com/terraform/install) | 1.8.0 | Infrastructure as code |
| [gcloud CLI](https://cloud.google.com/sdk/docs/install) | Latest | GCP authentication and debugging |
| [Git](https://git-scm.com/) | Latest | Version control |
| GitHub account | — | CI/CD pipelines |

## Required GCP IAM Roles

These roles must be granted at the **organization level** by a GCP Org Admin:

| Role | Who needs it | Purpose |
|------|-------------|---------|
| `roles/resourcemanager.organizationAdmin` | The user running bootstrap | Read org ID, create projects |
| `roles/resourcemanager.folderAdmin` | The user running bootstrap | Create environment folders |
| `roles/billing.user` | The user and stage SAs | Link billing to projects |
| `roles/iam.workloadIdentityPoolAdmin` | The bootstrap SA | Create WIF pool and provider |
| `roles/iam.serviceAccountAdmin` | The user running bootstrap | Create service accounts |
| `roles/orgpolicy.policyAdmin` | The user running bootstrap | Set organization policies |

## GitHub Repository Setup

1. Create a GitHub repository for this project.
2. Configure the following **repository secrets** (no static keys — use WIF):

| Secret | Description |
|--------|-------------|
| `WIF_PROVIDER` | Workload Identity Provider resource name |
| `WIF_SERVICE_ACCOUNT` | Service account email for impersonation |
| `TF_STATE_BUCKET` | GCS bucket name for remote state |
| `ORG_ID` | Google Cloud Organization ID |
| `BILLING_ACCOUNT` | Billing account ID |

## Verify Access

```bash
# Confirm you can see the org
gcloud organizations list

# Confirm your billing account is active
gcloud billing accounts list
```

Once these are in place, proceed to [Bootstrap](02-bootstrap.md).
