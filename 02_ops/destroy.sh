#!/usr/bin/env bash
set -euo pipefail

if [ "${1-}" != "dev" ] && [ "${1-}" != "prod" ]; then
  echo "Usage: $0 dev|prod"
  exit 1
fi

ENV="$1"

cd "$(dirname "$0")/../01_iac"

echo "[!]  About to destroy environment: $ENV"
echo "Press Ctrl+C to abort..."
sleep 3

terraform destroy -var-file="envs/${ENV}.tfvars"
