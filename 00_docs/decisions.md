# Architectural Decisions (WIP)

This file documents non-trivial architectural decisions and trade-offs.

## Decision 1 — Single Subscription Model
Reasoning:
- fits team size & cost structure
- reduces operational overhead
- accelerates onboarding

Trade-offs:
- weaker blast-radius controls vs multi-subscription
- entitlement boundaries via RG/RBAC instead of subscription

Status: accepted (MVP)

---

## Decision 2 — Terraform + GitHub Actions
Reasoning:
- aligns with developer familiarity
- reduces tooling footprint
- allows PR-based deployment flow

Status: accepted (MVP)

---

## Decision 3 — Cost Awareness via Budgets + Tags
Reasoning:
- simplest model for small teams
- no complex chargeback automation
- aligns with team ownership model

Status: accepted (MVP)

---

## Decision 4 — App Hosting via App Service / Functions
Reasoning:
- sufficient for small SaaS workloads
- reduces ops burden compared to AKS/K8s

Status: accepted (MVP)
