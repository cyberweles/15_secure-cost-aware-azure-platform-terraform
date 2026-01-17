# Architectural Decisions

This document captures the key design decisions for the project  
**“Secure, cost-aware Azure platform with Terraform (neb, dev/prod)”**.

---

## D-01 — Repository layout (00_docs / 01_iac / 02_ops)

**Decision**  
Use a three-layer structure:

- `00_docs` — context, scope, assumptions, decisions
- `01_iac` — Terraform code (modules + environments)
- `02_ops` — operational tooling (shell scripts, CI/CD templates)

**Reasoning**

- Mirrors common platform-team separation (design vs. code vs. operations).
- Simplifies review — docs and IaC are clearly discoverable.
- Keeps operational tooling versioned outside the Terraform module itself.

**Status**  
Accepted.

---

## D-02 — Multi-environment from a single codebase (dev/prod via tfvars)

**Decision**  
Use a **single Terraform codebase** with per-environment configuration:

- `01_iac/envs/dev.tfvars`
- `01_iac/envs/prod.tfvars`

**Reasoning**

- Reduces code duplication.
- Environment differences (naming, sizes, SKUs, budgets) are data-driven, not fork-driven.
- Enables evolving shared modules (core/app) without environments diverging.

**Status**  
Accepted.

---

## D-03 — Remote state per environment (neb-dev / neb-prod)

**Decision**  
Store Terraform state in a dedicated storage account and **split state per environment**:

- Resource group: `neb-weu-rg-tfstate`
- Storage account: `nebstateweu01`
- Container: `tfstate`
- Keys:
  - `neb-dev.tfstate`
  - `neb-prod.tfstate`

Configured via:

- `backend-dev.hcl`
- `backend-prod.hcl`

**Reasoning**

- Prevents dev/prod contention for a single state file.
- Easier to audit/backup environments independently.
- Standard pattern for small/mid platform/product teams.

**Status**  
Accepted.

---

## D-04 — AzureRM backend instead of local tfstate

**Decision**  
Use the `azurerm` backend with a dedicated RG + Storage Account instead of local state.

**Reasoning**

- Central, lockable, versionable state (blob + leases).
- Enables team collaboration without shipping `.tfstate` files.
- Local state is excluded from VCS, reducing secret leakage risk.

**Status**  
Accepted.

---

## D-05 — OIDC + Entra ID instead of Service Principal + Client Secret

**Decision**  
Authenticate Terraform in CI/CD via **GitHub OIDC → Entra ID**:

- App registration: `neb-terraform-github`
- Federated credentials:
  - `repo:cyberweles/15_secure-cost-aware-azure-platform-terraform:ref:refs/heads/main` (dev)
  - `repo:cyberweles/15_secure-cost-aware-azure-platform-terraform:environment:prod` (prod)

The `azurerm` provider uses the workload identity from `azure/login`, without client secrets.

**Reasoning**

- Removes credential secrets from GitHub (no rotation, lower leakage risk).
- Aligns with modern security posture (workload identity federation).
- Clear separation: branch for dev, environment for prod.

**Status**  
Accepted.

---

## D-06 — Explicit subscription/tenant configuration in provider

**Decision**  
Configure `azurerm` in `providers.tf` with explicit:

- `subscription_id`
- `tenant_id`

No `use_cli = true`.

**Reasoning**

- CI/CD authentication does not rely on local Azure CLI context.
- Explicit subscription/tenant improves reviewability and clarity.
- Eliminates “wrong local context” issues for developers.

**Status**  
Accepted.

---

## D-07 — Dev: auto-apply, Prod: gated apply (environment approval)

**Decision**

- **Dev** — pipeline runs `plan` + `apply` automatically on push.
- **Prod** — separate pipeline:
  - `plan` produces an artifact,
  - `apply` requires manual approval for environment `prod`.

**Reasoning**

- Dev prioritizes iteration speed and quick feedback.
- Prod introduces necessary human approval before infrastructure changes.
- Matches typical “lightweight guardrails” in small/mid product teams.

**Status**  
Accepted.

---

## D-08 — Operational scripts in 02_ops (verify / destroy)

**Decision**  
Place operational scripts in `02_ops`:

- `02_ops/verify.sh` — sanity checks (fmt, validate, plan dev/prod).
- `02_ops/destroy.sh` — controlled teardown (`destroy.sh dev|prod`).
- `02_ops/github-actions/*.yml` — source of truth for CI/CD pipelines.

**Reasoning**

- Separates IaC from operational tooling.
- `verify.sh` standardizes local validation before commit/PR.
- `destroy.sh` enforces conscious environment selection (minimizes accidental full destroy).

**Status**  
Accepted.

---

## D-09 — Use prefix `neb` as namespace baseline

**Decision**  
Apply a consistent `neb` prefix across resources:

- `neb-dev-weu-rg-core`, `neb-prod-weu-rg-core`
- `neb-dev-weu-app`, `neb-prod-weu-app`
- `neb-weu-rg-tfstate`, `nebstateweu01`, etc.

**Reasoning**

- Enables filtering/reporting for FinOps and governance.
- Differentiates from other sandboxes/projects.
- Reusable naming baseline for future (Kubernetes, workloads, etc.).

**Status**  
Accepted.

---

## D-10 — Budgets + logging as FinOps/observability baseline

**Decision**  
Implement:

- Budgets per environment (dev/prod) as early cost signals.
- Diagnostic settings → central Log Analytics Workspace (core + app).

**Reasoning**

- Project showcases not only Terraform, but **FinOps + operability thinking**.
- Budgets provide early alerts rather than relying on invoice inspection.
- Central logging simplifies troubleshooting and enables future alerts/queries.

**Status**  
Accepted.