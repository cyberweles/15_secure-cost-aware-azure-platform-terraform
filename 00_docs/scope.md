# Scope

**In scope**
✔ Terraform orchestration for two environments (dev/prod)  
✔ Remote state separation (per env)  
✔ Minimal landing zone (core + app modules)  
✔ OIDC → Entra ID for CI/CD (no client secrets)  
✔ Dev auto-apply, prod gated-apply (manual approval)  
✔ FinOps baseline (budgets per env)  
✔ Observability baseline (diagnostic settings → Log Analytics)  
✔ Operational tooling (`verify.sh`, `destroy.sh`)  
✔ Documentation for assumptions, decisions, and context  

**Out of scope**
✘ Full enterprise landing zone (policy, compliance, shared services catalog)  
✘ Multi-tenant or multi-subscription patterns  
✘ Network peering, VPN, private endpoints, private DNS  
✘ Complex workload (Kubernetes, queues, databases, multi-tier microservices)  
✘ Full cost optimization or anomaly detection  
✘ Incident response / SRE playbooks  

**Target persona**
- small/mid product team
- no formal platform department
- early FinOps + SecOps awareness
- focus on leverage, not compliance

**Success criteria**
- dev/prod deployments are repeatable
- prod deployments are gated and require explicit approval
- no secrets stored in CI/CD
- state is survivable and reviewable
- cost & diagnostic signals exist from day one

**Non-goals**
- maximizing automation at all costs
- recreating cloud vendor blueprints
- simulating enterprise compliance frameworks
