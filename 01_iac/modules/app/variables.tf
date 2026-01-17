variable "env" {
  type        = string
  description = "Environment (dev/prod)."
}

variable "location" {
  type        = string
  description = "Azure location."
}

variable "prefix" {
  type        = string
  description = "Resource name prefix."
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for app resources."
}

variable "core_resource_group_name" {
  type        = string
  description = "Reference to core RG (for shared resources, if needed)."
}

variable "log_analytics_workspace_id" {
  type = string
}
