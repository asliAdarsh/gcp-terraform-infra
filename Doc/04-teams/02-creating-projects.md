# Creating Projects with the Service-Project Module

**Module:** `Modules/service-project/`

Every Spoke team's `main.tf` calls this module to create their GCP project. It handles the boilerplate so teams can focus on resources, not project setup.

## What the Module Does

```
service-project module
├── Creates GCP project under the team's folder
├── Enables required APIs (configurable via var.apis)
├── Attaches project to the Shared VPC host project
├── Waits for API propagation (30s sleep)
└── Optionally creates (via sub-modules):
    ├── VM instance (compute-vm module)
    ├── Cloud SQL (cloud-sql module)
    └── Storage bucket (storage-bucket module)
```

## Key Variables

| Variable | Description |
|----------|-------------|
| `project_name` | Short name like `"myapp"` |
| `project_id` | Optional override; defaults to `sb-{env}-{name}` |
| `environment_folder_id` | Team folder ID from Core remote state |
| `host_project_id` | Shared VPC host project ID from Networks remote state |
| `subnet_self_link` | Subnet to attach VM to |
| `apis` | List of GCP APIs to enable |
| `create_vm` / `create_sql` / `create_bucket` | Booleans to create optional resources |

## How a Team Uses It

```hcl
# Workload/Spoke/YourTeam/main.tf
module "project" {
  source = "../../../Modules/service-project"
  # ... variables from Deployment/Spoke/YourTeam/{env}.tfvars
}
```

The module outputs `project_id` and `project_number` for use by custom resources added in the same `main.tf`.

## Remote State Dependencies

The Spoke `main.tf` reads two remote states:
- **Core** — to get the team's folder ID
- **Networks** — to get subnet link and host project ID

These are fetched via `terraform_remote_state` data sources in the template.
