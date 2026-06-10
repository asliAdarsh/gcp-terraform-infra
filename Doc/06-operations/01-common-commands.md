# Common Commands

## Stage by Stage

### Stage 1: Bootstrap (run once, local)

```bash
cd 01bootstrap
terraform init
terraform plan          # review before applying
terraform apply
```

### Stage 2: Organization

```bash
cd 02organization
terraform init -backend-config="bucket=YOUR_STATE_BUCKET"
terraform plan -var-file="../Deployment/Core/dev.tfvars"
terraform apply -var-file="../Deployment/Core/dev.tfvars"
```

### Stage 3: Networks

```bash
cd 03networks
terraform init -backend-config="bucket=YOUR_STATE_BUCKET"
terraform plan
terraform apply
```

### Stage 4: Core (team folders)

```bash
cd Workload/Core
terraform init -backend-config="bucket=YOUR_STATE_BUCKET"
terraform plan -var-file="../../Deployment/Core/dev.tfvars"
terraform apply -var-file="../../Deployment/Core/dev.tfvars"
```

### Stage 4: Spoke (team resources)

```bash
cd Workload/Spoke/Clynz
terraform init -backend-config="bucket=YOUR_STATE_BUCKET"
terraform plan -var-file="../../../Deployment/Spoke/Clynz/dev.tfvars"
terraform apply -var-file="../../../Deployment/Spoke/Clynz/dev.tfvars"
```

## Helpful gcloud Commands

```bash
# List organizations
gcloud organizations list

# List billing accounts
gcloud billing accounts list

# Check org IAM for a service account
gcloud organizations get-iam-policy YOUR_ORG_ID \
  --filter="bindings.members:SA_EMAIL" \
  --format="table(bindings.role)"

# List available org policy constraints
gcloud org-policies list-constraints --organization=YOUR_ORG_ID

# Force unlock Terraform state
terraform force-unlock LOCK_ID

# Reinitialize backend after config change
terraform init -reconfigure

# Migrate local state to remote
terraform init -migrate-state
```

## Git Workflow

```bash
# Create a feature branch
git checkout -b feat/my-change

# After making changes
git add -A
git commit -m "feat: description of change"
git push -u origin feat/my-change
# Then open a PR on GitHub
```
