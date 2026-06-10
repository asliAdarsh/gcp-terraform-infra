# VPC and Subnets

**Folder:** `03networks/`

## Hub VPC Design

A single Hub VPC is created in the host project using the `hub-vpc` module. All service projects attach to this VPC via Shared VPC.

```
Hub VPC (projects/host-project/global/networks/hub-vpc)
├── subnet-dev     (10.0.0.0/20, asia-south1)
├── subnet-staging (10.0.16.0/20, asia-south1)
└── subnet-prod    (10.0.32.0/20, asia-south1)
```

## Why Hub VPC (not VPC Peering)?

- **Centralized egress** — NAT and Cloud VPN live in the hub
- **Simpler routing** — no mesh of peerings between teams
- **Auditable** — firewall rules are defined once, not per-project
- **Cost effective** — fewer NAT gateways, fewer VPN tunnels

## Subnet Layout

| Environment | CIDR | Region | Purpose |
|-------------|------|--------|---------|
| dev | 10.0.0.0/20 | asia-south1 (Mumbai) | Development workloads |
| staging | 10.0.16.0/20 | asia-south1 (Mumbai) | Pre-production testing |
| prod | 10.0.32.0/20 | asia-south1 (Mumbai) | Production workloads |

Each subnet has private Google access enabled so VMs can reach Google APIs without a public IP.

## Remote State Outputs

After apply, the networks stage exposes these outputs consumed by Spoke teams:

- `subnet_self_links` — map of environment to subnet self-link
- `host_project_id` — the Shared VPC host project ID
- `network_self_link` — the VPC self-link
