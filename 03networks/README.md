# Networks Stage — Shared VPC, Subnets, NAT, Firewall & DNS

Creates the shared VPC infrastructure in the host project.

## What it builds

| Resource | Name | Purpose |
|----------|------|---------|
| **VPC** | `vpc-shared` | The shared network for all service projects |
| **Subnets** | `vpc-shared-dev` | Dev subnet in asia-south1 (10.0.1.0/24) |
| | `vpc-shared-staging` | Staging subnet in asia-south1 (10.0.2.0/24) |
| | `vpc-shared-prod` | Prod subnet in asia-south1 (10.0.3.0/24) |
| **Cloud Router** | `vpc-shared-router-asia-south1` | For NAT configuration |
| **Cloud NAT** | `vpc-shared-nat-asia-south1` | Outbound connectivity for private VMs |
| **Firewall Rules** | Various | IAP SSH/RDP, health checks, internal traffic, default deny |
| **DNS Zone** | `internal` | Private DNS for internal resolution |

## Prerequisites

Bootstrap + Organization stages must be complete.

## How to run

```bash
cd 03networks
cp terraform.tfvars.example terraform.tfvars
terraform init -backend-config="bucket=YOUR_STATE_BUCKET"
terraform plan
terraform apply
```

## Outputs used by next stage

- `vpc_self_link` — for attaching service projects
- `subnet_self_links` — for subnet-level IAM per environment
- `host_project_id` — passed through from organization stage
