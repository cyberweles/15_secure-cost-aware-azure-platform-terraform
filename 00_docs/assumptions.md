# Assumptions

## Organizational
- No dedicated SRE/Platform department initially
- Developers deploy application workloads
- Security/governance pragmatic (not enterprise-scale)
- Single subscription is sufficient at this stage

## Architectural
- Environments: `dev` and `prod`
- Resource groups as primary isolation boundary
- One VNet per environment
- Key Vault for secrets
- Log Analytics for observability
- App workloads via App Service or Function App

## Governance & FinOps
- Tagging required: `owner`, `costCenter`, `env`, `app`, `workloadType`
- Cost allocation via budgets + tags
- RBAC split between platform vs application roles

## CI/CD
- Terraform plan on PR
- Terraform apply on merge
- Manual approval required for prod
- Remote state backend
