# Onboarding a New Team

Adding a new team to the infrastructure involves 5 steps. Here's the full workflow.

## Step 1: Add Team to Core

Edit `Deployment/Core/dev.tfvars` (and `staging.tfvars`, `prod.tfvars`):

```
teams = ["Clynz", "Totes", "YourTeam"]
```

When the Core pipeline runs, it creates a folder for `YourTeam` under each environment.

## Step 2: Create Team tfvars

Create `Deployment/Spoke/YourTeam/dev.tfvars`. Use placeholders — never commit real GCP IDs:

```
project_name      = "your-app"
project_id        = null
environment       = "dev"
team_name         = "YourTeam"
region            = "asia-south1"
billing_account_id = "BILLING_ACCOUNT_ID"
apis              = ["compute.googleapis.com", "container.googleapis.com"]
create_vm         = false
create_sql        = false
create_bucket     = true
```

## Step 3: Create Team main.tf

Copy `Workload/Spoke/_template/` to `Workload/Spoke/YourTeam/` and update the module configuration with your team's variables. This creates the project, attaches it to the Shared VPC, and enables the APIs you listed.

## Step 4: Create Team Workflow

Copy `.github/workflows/_template.yaml` to `.github/workflows/yourteam.yaml`. Replace `{TEAM}` with `YourTeam` in 5 places (name, both path blocks, and the `workload-path` input).

## Step 5: Open a PR

Open a PR with all changes. The `pr-check.yaml` workflow runs `terraform fmt -check` and validates any changed modules. After merge, the team pipeline triggers automatically.

## What the Team Gets

- A folder under each environment
- A GCP project in their team folder
- Access to the Shared VPC
- A CI/CD pipeline triggered on their code
