# Firewall and NAT

**Folder:** `03networks/`

## Cloud NAT

A Cloud NAT gateway is configured per region (currently `asia-south1`). All instances in the Hub VPC that don't have public IPs use this NAT for outbound internet access.

```
[VM on Hub VPC] --private IP--> [Cloud NAT] --> internet
```

NAT is configured with:
- **Manual IP allocation** — a small block of reserved external IPs
- **Logging** — enabled for debugging egress traffic
- **Minimal ports per VM** — 64 to keep port exhaustion manageable

## Firewall Rules

Rules are defined in the `firewall` module. The goal is **least privilege by default, with explicit allow rules**.

### Default Rules

| Rule | Source | Destination | Purpose |
|------|--------|-------------|---------|
| Allow IAP SSH | `35.235.240.0/20` (IAP range) | All instances with tag `iap-ssh` | Secure SSH via IAP |
| Allow health checks | GCP health check ranges | All instances | Load balancer health checks |
| Deny all ingress | `0.0.0.0/0` | All instances (lowest priority) | Default deny |

### Adding Team-Specific Rules

Each Spoke team can add firewall rules in their own `main.tf` by referencing the Hub VPC's `network_self_link`. Rules target specific service accounts or tags to keep scope narrow.

## DNS

Private DNS zones are configured for internal service discovery. The hub VPC has:
- `google.internal.` — private zone for internal services
- A forwarding zone configured if on-prem DNS integration is needed
