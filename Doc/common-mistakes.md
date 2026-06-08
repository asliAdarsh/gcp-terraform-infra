# Common Mistakes & Troubleshooting

A collection of errors encountered across all stages, with causes and fixes.

---

## Stage 1: Bootstrap

### 1. Project name is too long or has invalid characters

**Error:**
```
"Bootstrap Infrastructure - State" name must be 4 to 30 characters...
```

**Cause:** `google_project.name` has a **30-character limit** and only allows letters, numbers, spaces, hyphens, single/double quotes, and exclamation points. No slashes, underscores, or special chars.

**Fix:** Shorten the name. Remove unnecessary words and special chars.
- ❌ `"Bootstrap Infrastructure - State"` (32 chars, has `-`)
- ✅ `"Bootstrap State Infrastructure"` (28 chars)
- ❌ `"Bootstrap CI/CD"` (has `/`)
- ✅ `"Bootstrap CICD"`

---

### 2. `billing_account_id` is not a valid attribute

**Error:**
```
Unexpected attribute: An attribute named "billing_account_id" is not expected here
```

**Cause:** The `google_project` resource uses `billing_account`, not `billing_account_id`.

**Fix:**
```hcl
# ❌ Wrong
billing_account_id = var.billing_account_id

# ✅ Correct
billing_account = var.billing_account_id
```

---

### 3. Project already exists (409 Conflict)

**Error:**
```
Error 409: Requested entity already exists, alreadyExists
```

**Cause:** A project with the same `project_id` was previously created (or the ID is taken globally).

**Fix:** Use a unique project ID by adding a suffix:
```hcl
# ❌ Taken
project_id = "bootstrap-cicd"

# ✅ Unique
project_id = "bootstrap-cicd-18792"
```

---

### 4. `iam.workloadIdentityPools.create` permission denied

**Error:**
```
Error 403: Permission 'iam.workloadIdentityPools.create' denied
```

**Cause:** The service account is missing the `roles/iam.workloadIdentityPoolAdmin` role.

**Fix:** Ask your Org Admin to grant:
```bash
gcloud organizations add-iam-policy-binding <ORG_ID> \
  --member="serviceAccount:YOUR_SA@PROJECT.iam.gserviceaccount.com" \
  --role="roles/iam.workloadIdentityPoolAdmin"
```

**Prevention:** This role is easy to forget — always include it in your initial IAM setup checklist.

---

### 5. Local state files remain after `terraform init -migrate-state`

**Symptom:** `terraform.tfstate` and `terraform.tfstate.backup` still exist locally after migration.

**Cause:** `terraform init -migrate-state` copies state to the remote backend but does NOT delete local files (by design — safety measure).

**Fix:** The files are now stale. Delete them:
```bash
rm 01bootstrap/terraform.tfstate 01bootstrap/terraform.tfstate.backup
```

These files are already in `.gitignore`, so they won't be committed.

---

## Stage 2: Organization

### 1. Folder creation fails — missing permission

**Error:**
```
Error 403: Permission 'resourcemanager.folders.create' denied
```

**Cause:** Service account doesn't have `roles/resourcemanager.folderAdmin` at the org level.

**Fix:** Verify the role is granted at the **organization** level (not project level):
```bash
gcloud organizations get-iam-policy <ORG_ID> \
  --filter="bindings.members:YOUR_SA_EMAIL" \
  --format="table(bindings.role)"
```

---

### 2. Host project creation fails — billing not linked

**Error:**
```
Error 403: Cloud billing API is not available
```

**Cause:** The billing account is not linked to the organization, or `roles/billing.user` is missing.

**Fix:**
```bash
# Verify billing account is valid
gcloud billing accounts list

# Verify SA has billing.user
gcloud organizations get-iam-policy <ORG_ID> \
  --filter="bindings.role=roles/billing.user"
```

---

### 3. Org policy constraint not found

**Error:**
```
Error 404: Policy constraint 'compute.requireShieldedVm' not found
```

**Cause:** Some org policy constraints may not be available in all orgs or may have different names.

**Fix:** List available constraints:
```bash
gcloud org-policies list-constraints --organization=<ORG_ID>
```
Then update the constraint name in `main.tf` to match an available one.

---

### 4. Shared VPC host project fails

**Error:**
```
Error: google_compute_shared_vpc_host_project: Compute API not enabled
```

**Cause:** `compute.googleapis.com` isn't enabled on the host project yet.

**Fix:** Terraform creates the project and enables APIs in parallel. The `google_compute_shared_vpc_host_project` resource has an implicit dependency on the compute API service. If it fails, add an explicit `depends_on`:
```hcl
resource "google_compute_shared_vpc_host_project" "host_project" {
  project    = google_project.host_project.project_id
  depends_on = [google_project_service.host_project_apis]
}
```

---

## Stage 3: Networks (Coming Soon)

*To be filled as issues are encountered.*

---

## Stage 4: Service Projects (Coming Soon)

*To be filled as issues are encountered.*

---

## General Terraform Issues

### 1. State locked

**Error:**
```
Error: Error acquiring the state lock
```

**Cause:** Another `terraform apply` is running, or a previous run was interrupted.

**Fix:**
- Wait for the other run to finish
- If stuck, force unlock:
```bash
terraform force-unlock <LOCK_ID>
```

---

### 2. Backend initialization required

**Error:**
```
Error: Backend initialization required
```

**Cause:** The backend config was changed but `terraform init` wasn't re-run.

**Fix:**
```bash
terraform init -reconfigure
```

---

### 3. Service account impersonation fails

**Error:**
```
Error 403: The caller does not have permission to impersonate this service account
```

**Cause:** The `iamcredentials.googleapis.com` API is not enabled, or the user doesn't have `roles/iam.serviceAccountTokenCreator`.

**Fix:**
```bash
# Enable the API
gcloud services enable iamcredentials.googleapis.com

# Grant impersonation
gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="user:YOUR_EMAIL" \
  --role="roles/iam.serviceAccountTokenCreator"
```
