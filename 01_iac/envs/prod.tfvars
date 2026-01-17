env      = "prod"
location = "westeurope"
prefix   = "neb"

common_tags = {
  owner        = "nebula-platform"
  costCenter   = "NT-PROD-001"
  app          = "nebula-tasks"
  workloadType = "saas-core"
}

monthly_budget_amount = 200

budget_contact_emails = [
  "nebula-finops@example.com"
]

platform_principal_id = ""
app_principal_id      = ""