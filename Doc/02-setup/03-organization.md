# Stage 2: Organization

**Folder:** `02organization/`

Creates the folder hierarchy, Shared VPC host project, and sets organization-level IAM and policies.

## What Gets Created

### 1. Environment Folders

```
f-dev/  f-staging/  f-prod/
```

Each environment gets a top-level folder under the organization. Team sub-folders are NOT created here — that happens in the Core stage.

### 2. Shared VPC Host Project

A dedicated project that hosts the Shared VPC. All service projects (created by Spoke teams) attach to this VPC. This project also gets the org-level service account bindings so the networks and service-projects SAs can operate.

### 3. Organization Policies

Common org policy constraints are applied:
- `compute.requireShieldedVm` — enforce shielded VMs
- `storage.uniformBucketLevelAccess` — enforce uniform bucket-level IAM
- `iam.disableServiceAccountKeyCreation` — prevent service account key creation
- `compute.skipDefaultNetworkCreation` — prevent default VPC creation

## Dependencies

This stage reads remote state from Stage 1 (bootstrap) via `terraform_remote_state` to get the bucket name and service account emails.

## How to Run

```bash
cd 02organization
terraform init -backend-config="bucket=YOUR_STATE_BUCKET"
terraform apply
```

## Service Account Permissions

The `terraform-org` service account needs these roles at the **organization level**:
- `roles/resourcemanager.folderAdmin` — to create folders
- `roles/resourcemanager.projectCreator` — to create the host project
- `roles/billing.user` — to link billing
- `roles/orgpolicy.policyAdmin` — to set org policies

These are assigned during bootstrap and must be verified before applying.
