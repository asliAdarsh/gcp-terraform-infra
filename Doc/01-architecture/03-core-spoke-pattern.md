# Core/Spoke Pattern

After the 3 bootstrap stages complete, the repo uses a **Core/Spoke** pattern for multi-team collaboration.

## Why Core/Spoke?

A single team repo works fine for one team. When you have multiple teams (Clynz, Totes, etc.) you need isolation without duplication. Core/Spoke solves this:

- **Core** owns the folder structure — it creates one sub-folder per team under each environment
- **Spoke** gives each team their own Terraform root module to manage whatever resources they need

```
Workload/
├── Core/                     # One terraform root module
│   └── main.tf              #   google_folder.team["Clynz"], google_folder.team["Totes"]
└── Spoke/
    ├── Clynz/main.tf         # Clynz's project + resources
    └── Totes/main.tf         # Totes's project + resources
```

## How Core Works

`Workload/Core/main.tf` reads a list of teams from a `.tfvars` file:

```
# Deployment/Core/dev.tfvars
teams = ["Clynz", "Totes"]
```

For each team, it creates a `google_folder` resource under the current environment's folder. That's it — Core does not create projects or resources.

## How Spoke Works

Each Spoke team has a `main.tf` that reads remote state from Core and Networks to get:

- Their **team folder ID** (so the project lands in the right folder)
- The **subnet self-link** and **host project ID** (to attach to Shared VPC)

Then they call the `service-project` module to create their project, enable APIs, and attach to the Shared VPC. After that, they add any custom resources.

## Benefits

- **Teams don't step on each other** — their Terraform state is separate
- **Shared network stays consistent** — Core owns it, no team can break it
- **No copy-paste** — the `service-project` module handles the boilerplate
- **Each team moves at their own pace** — different environments, different schedules
