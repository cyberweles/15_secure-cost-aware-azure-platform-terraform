#!/usr/bin/env bash
set -euo pipefail

# Go to IaC folder
cd "$(dirname "$0")/../01_iac"

echo ">> terraform fmt -check"
terraform fmt -check

echo ">> terraform validate"
terraform validate

echo ">> terraform plan (dev)"
terraform plan -var-file="envs/dev.tfvars"

echo ">> terraform plan (prod)"
terraform plan -var-file="envs/prod.tfvars"

echo "[OK] verify.sh completed (dev + prod plans ok)"
