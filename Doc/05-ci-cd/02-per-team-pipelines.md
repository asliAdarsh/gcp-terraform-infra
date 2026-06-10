# Per-Team Pipeline Pattern

Each team has its own workflow file that triggers only on their code.

## How It's Structured

```
.github/workflows/
├── deploy-app.yaml     # Reusable — contains the actual deploy logic
├── clynz.yaml          # Delegates to deploy-app.yaml
├── totes.yaml          # Delegates to deploy-app.yaml
└── _template.yaml      # Copy this for new teams
```

## Team Workflow Anatomy

Each team workflow does three things:

1. **Scopes triggers** — only fires when the team's paths change (plus shared `Modules/`)
2. **Passes the workload path** — e.g., `Spoke/Clynz`
3. **Delegates to `deploy-app.yaml`** — the reusable workflow handles init, plan, and apply

## Module Change Propagation

When a shared module (e.g., `Modules/service-project/`) changes, **all** team workflows that reference that module trigger. This ensures that module updates are validated against every team that uses them.

Update the path list in `_template.yaml` when adding a new module:

```yaml
paths:
  - 'Deployment/Spoke/{TEAM}/**'
  - 'Workload/Spoke/{TEAM}/**'
  - 'Modules/service-project/**'
  - 'Modules/compute-vm/**'
  # - 'Modules/gke-cluster/**'  ← uncomment when module is added
```

## PR Checks

When any PR is opened, `pr-check.yaml` validates:

- **`terraform fmt -check -recursive`** — all files must be formatted
- **`terraform validate`** — each changed Workload directory is validated with `-backend=false`

This catches formatting issues and syntax errors before review.

## Adding a Team Workflow

Copy `_template.yaml`, rename it, and replace `{TEAM}` with the team name. That's it.
