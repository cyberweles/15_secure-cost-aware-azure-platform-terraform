# Context

Small/mid product companies often start their cloud journey without a dedicated
platform team. Infrastructure grows from ad-hoc deployments, manual changes and
tribal knowledge. Over time, three pressures emerge:

1. **Cost awareness (FinOps)**
   Cloud bills become non-trivial and difficult to attribute or explain.

2. **Operational consistency**
   Manual deployment paths introduce drift and troubleshooting becomes slow.

3. **Security & access control**
   Secrets accumulate in CI/CD systems; identities are user-driven instead of workload-driven.

This project simulates a lightweight platform skeleton for such an environment:
- two realistic environments (`dev` & `prod`)
- cost signals (budgets)
- observability baseline (diagnostics to LAW)
- IaC enforcement (Terraform)
- CI/CD without secrets (OIDC → Entra ID)

The goal is not to build a “complete enterprise landing zone” but to show how a
small platform team can improve security, repeatability and cost visibility
without overengineering.
