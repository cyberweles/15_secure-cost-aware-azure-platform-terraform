# Assumptions

This project makes a set of simplifying assumptions to keep the scope aligned
with a realistic small/mid product platform without overengineering.

---

## Business / Team assumptions

1. **Small platform footprint**
   The team operates 1–3 core environments (dev, prod).
   Staging/preprod is skipped for simplicity.

2. **Product > compliance**
   Product velocity, operational clarity and cost-awareness
   are prioritized over enterprise compliance or governance.

3. **Single subscription**
   Multi-subscription patterns (hub/spoke or org-level landing zones)
   are out of scope.

4. **Low ceremony deployments**
   Developers/platform engineers can trigger dev deployments without audits;
   prod requires explicit approval but no CAB processes.

---

## Security assumptions

5. **OIDC over secrets**
   All automation identities are federated via Entra ID workload identity;
   no client secrets or passwords are stored in CI/CD.

6. **RBAC at subscription scope**
   App registration is granted `Contributor` on subscription.
   More granular scopes are possible in real deployments but not required here.

7. **No private networking**
   All services are publicly reachable (App Service, LAW ingest).
   Private endpoints, VPN, ExpressRoute and peering are intentionally excluded.

8. **No customer data**
   Workloads are synthetic; no privacy or data residency constraints.

---

## Infrastructure assumptions

9. **Single region**
   Region is fixed to `westeurope`; multi-region and failover are out of scope.

10. **State persistence**
   Terraform state is durable and remote (Azure Storage backend),
   split by environment (dev/prod).

11. **Minimal workload**
   App module represents lightweight PaaS workloads
   (e.g., App Service + Diagnostic + Budgets)
   as a placeholder for real business workloads.

12. **Simple networking**
   VNet is minimal; no segmentation, no NAT, no WAF, no firewall appliances.

---

## FinOps / Observability assumptions

13. **Early cost signals**
   Budgets represent cost awareness, not enforcement.

14. **Centralized diagnostics**
   Observability baseline = Log Analytics Workspace + diagnostic settings.
   No alerting, dashboards or SLO/SLA defined at this stage.

---

## Operational assumptions

15. **GitHub as CI/CD**
   GitHub Actions acts as the platform CI/CD with OIDC auth.

16. **Dev auto-apply, prod gated**
   Deployment model intentionally differentiates risk profiles;
   no ephemeral preview environments.

17. **Manual teardown**
   Environments can be destroyed via explicit `destroy.sh dev|prod`
   and are not auto-cleaned.

---

## Non-technical assumptions

18. **No vendor negotiations**
   FinOps components assume pay-as-you-go without reserved instances,
   savings plans, or Azure Hybrid Benefit.

19. **Incremental evolution**
   This skeleton is meant to evolve toward richer policies, governance
   and more complex workloads in future iterations.
