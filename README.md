# 15 — Secure, cost-aware Azure Platform (Terraform, OIDC, Dev/Prod)

This repository contains a small but realistic **Azure platform skeleton** for a product team:

- **Terraform** for core + app landing zone (dev & prod)
- **Remote state per environment** (Azure Storage backend)
- **GitHub Actions + OIDC** for CI/CD
- **Dev = auto-apply**, **Prod = gated apply** (manual approval)
- **FinOps & Ops baseline**: budgets, diagnostics, verify/destroy scripts

The project is designed as a **portfolio-grade** example rather than another Terraform “hello world”.

## 1. Repository structure

```text
.
├── 00_docs
│   ├── assumptions.md
│   ├── context.md
│   ├── decisions.md
│   └── scope.md
├── 01_iac
│   ├── backend-dev.hcl
│   ├── backend-prod.hcl
│   ├── envs
│   │   ├── dev.tfvars
│   │   └── prod.tfvars
│   ├── main.tf
│   ├── modules
│   │   ├── core
│   │   └── app
│   ├── outputs.tf
│   ├── providers.tf
│   └── variables.tf
├── 02_ops
│   ├── destroy.sh
│   ├── github-actions
│   └── verify.sh
└── README.md
```

## 2. Core ideas

### Platform, not just Terraform

- Single codebase, multiple envs (dev/prod via tfvars)
- Separate remote states (`neb-dev.tfstate`, `neb-prod.tfstate`)
- OIDC → Entra ID → azurerm backend/provider (no client secrets)
- CI/CD risk model:
  - **dev**: fast iteration
  - **prod**: plan + manual approval

### FinOps & operability

- Budgets per env as **early cost signal**
- LAW + diagnostic settings as **observability baseline**
- `verify.sh` + `destroy.sh` as **minimal operational toolkit**

## 3. Prerequisites

### Local

- Terraform ≥ 1.5
- Azure CLI (`az`)
- Contributor access to a subscription (lab context)

### Remote backend (Azure Storage)

- Resource group: `neb-weu-rg-tfstate`
- Storage account: `nebstateweu01`
- Container: `tfstate`

### CI/CD (GitHub + Entra ID)

- App Registration: `neb-terraform-github`
- Federated credentials for:
  - branch `main` → dev pipeline
  - environment `prod` → prod pipeline
- RBAC Contributor for this app on subscription or RG scope

## 4. Local workflows

### 4.1 Dev — create/update

```bash
cd 01_iac

terraform init -backend-config="backend-dev.hcl"
terraform plan  -var-file="envs/dev.tfvars"
terraform apply -var-file="envs/dev.tfvars"
```

### 4.2 Prod — create/update

```bash
cd 01_iac

terraform init -backend-config="backend-prod.hcl"
terraform plan  -var-file="envs/prod.tfvars"
terraform apply -var-file="envs/prod.tfvars"
```

### 4.3 Verify (dev + prod)

From repo root:

```bash
./02_ops/verify.sh
```

### 4.4 Controlled destroy

```bash
./02_ops/destroy.sh dev
./02_ops/destroy.sh prod
```

## 5. CI/CD (GitHub Actions)

`02_ops/github-actions` contains workflow templates for:

### Terraform Plan (dev/prod)

- checkout
- azure/login (OIDC)
- terraform init (backend per env)
- fmt, validate, plan
- upload plan artifact (prod)

### Terraform Apply

- **dev** — auto apply on push to `main`
- **prod** — apply with `environment: prod` + manual approval

## 6. What this project demonstrates

- Platform/cloud mindset, not just Terraform execution
- Conscious use of:
  - remote state per env
  - OIDC instead of secret SPs
  - differentiated dev/prod risk profiles
- Minimal but real operational tooling
- Baseline for future projects

## 7. Possible next steps

- Add policy baseline (deny public IPs, enforce tags)
- Add LAW-based alerting (cost + infra signals)
- Extend verify.sh with drift-check (`plan -detailed-exitcode`)
- Deploy workloads (AKS / AppService)
- Add FinOps dashboards & tagging strategies
