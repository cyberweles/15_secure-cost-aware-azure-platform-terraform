variable "env" {
  type = string
  description = "Environment (dev/prod)."
}

variable "location" {
    type = string
    description = "Azure location."  
}

variable "prefix" {
    type = string
    description = "Resource name prefix."
  
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for core resources."
}

variable "vnet_address_space" {
  type = list(string)
  description = "Address space for the core virtual network."
}

variable "app_subnet_prefix" {
  type = string
  description = "Address prefix for the app subnet."
}

variable "data_subnet_prefix" {
  type = string
  description = "Address prefix for the data subnet."
}