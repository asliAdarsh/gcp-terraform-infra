# Adding Custom Resources

After the `service-project` module creates the project, teams add their own GCP resources in the same `main.tf`.

## Pattern

The `service-project` module exports `project_id` and `project_number`. Custom resources reference these outputs:

```hcl
module "project" {
  source = "../../../Modules/service-project"
  # ... team config
}

# Your custom resources go here
resource "google_container_cluster" "k8s" {
  name     = "${module.project.project_id}-cluster"
  project  = module.project.project_id
  location = var.region
  # ...
}
```

## Available Modules

| Module | Path | What It Creates |
|--------|------|----------------|
| service-project | `Modules/service-project/` | Project + Shared VPC attachment |
| compute-vm | `Modules/compute-vm/` | Single VM with IAP SSH |
| cloud-sql | `Modules/cloud-sql/` | PostgreSQL instance |
| storage-bucket | `Modules/storage-bucket/` | GCS bucket with uniform access |
| firewall | `Modules/firewall/` | Firewall rules on the hub VPC |

## Adding Resources Not Covered by Modules

You are not limited to the modules. You can write any Terraform resource directly in your `main.tf`:

- GKE clusters (`google_container_cluster`)
- Cloud Run services (`google_cloud_run_service`)
- Memorystore Redis (`google_redis_instance`)
- Pub/Sub topics (`google_pubsub_topic`)
- Cloud Functions (`google_cloudfunctions_function`)

## When to Create a New Module

If multiple teams need the same resource type (e.g., a GKE cluster with standard config), add it to `Modules/` as a reusable module and update the workflow path triggers to include it. See `Modules/` for examples.

## Important

Custom resources that need Shared VPC access should use the `subnet_self_link` and `host_project_id` from the remote state data sources in the template.
