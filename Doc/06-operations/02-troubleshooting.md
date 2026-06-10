# Troubleshooting

Common errors encountered across all stages, with causes and fixes.

---

## Stage 1: Bootstrap

### Project name is too long or has invalid characters

**Error:** `"Bootstrap Infrastructure - State"` name must be 4 to 30 characters.

**Cause:** `google_project.name` has a 30-character limit and restricts special characters.

**Fix:** Shorten the name. Remove hyphens, slashes, underscores.
- `"Bootstrap Infrastructure - State"` (32 chars, has `-`) -> `"Bootstrap State Infrastructure"` (28 chars)
- `"Bootstrap CI/CD"` (has `/`) -> `"Bootstrap CICD"`

### `billing_account_id` is not a valid attribute

**Cause:** The `google_project` resource uses `billing_account`, not `billing_account_id`.

**Fix:** Change `billing_account_id = var.billing_account_id` to `billing_account = var.billing_account_id`.

### Project already exists (409 Conflict)

**Cause:** A project with the same `project_id` is taken globally.

**Fix:** Append a unique suffix: `bootstrap-cicd-18792` instead of `bootstrap-cicd`.

### WIF permission denied

**Error:** `Permission 'iam.workloadIdentityPools.create' denied`.

**Cause:** The service account is missing `roles/iam.workloadIdentityPoolAdmin`.

**Fix:** Ask an Org Admin to grant it at the org level.

### Local state files remain after migration

**Symptom:** `terraform.tfstate` and `.backup` still exist locally.

**Cause:** `terraform init -migrate-state` copies state but doesn't delete local files.

**Fix:** Delete them — they are in `.gitignore` already.

---

## Stage 2: Organization

### Folder creation fails

**Error:** `Permission 'resourcemanager.folders.create' denied`.

**Cause:** SA missing `roles/resourcemanager.folderAdmin` at the org level (not project level).

**Fix:** Verify with `gcloud organizations get-iam-policy`.

### Billing not linked

**Error:** `Cloud billing API is not available`.

**Cause:** Billing account not linked to org, or `roles/billing.user` missing.

**Fix:** Verify billing account is valid and the SA has the role.

### Org policy constraint not found

**Error:** `Policy constraint 'compute.requireShieldedVm' not found`.

**Cause:** Constraint name may differ or not be available in your org.

**Fix:** List constraints with `gcloud org-policies list-constraints --organization=ORG_ID`.

### Shared VPC host project fails

**Error:** `google_compute_shared_vpc_host_project: Compute API not enabled`.

**Cause:** API enable and Shared VPC resource run in parallel.

**Fix:** Add `depends_on = [google_project_service.host_project_apis]`.

---

## General Terraform

### State locked

**Fix:** Wait for other run to finish, or `terraform force-unlock LOCK_ID`.

### Backend initialization required

**Fix:** Re-run `terraform init -reconfigure` after backend config changes.

### Service account impersonation fails

**Cause:** `iamcredentials.googleapis.com` not enabled, or missing `roles/iam.serviceAccountTokenCreator`.

**Fix:** Enable the API and grant the role.
