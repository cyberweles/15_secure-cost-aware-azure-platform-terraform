variable "env" {
  description = "Environment name (e.g. dev, prod)."
  type        = string
}

variable "location" {
  description = "Azure location (e.g. westeurope)"
  type        = string
}

variable "prefix" {
  description = "Resource name prefix (e.g. neb)"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "monthly_budget_amount" {
  description = "Monthly cost budget amount for this environment (in the subscription currency)."
  type        = number
}

variable "budget_contact_emails" {
  description = "Email addresses to notify when budget thresholds are exceeded."
  type        = list(string)
  default     = []
}

variable "platform_principal_id" {
  type        = string
  description = "Principal ID for platform team (RBAC)."
}

variable "app_principal_id" {
  type        = string
  description = "Principal ID for app team (RBAC)."
}