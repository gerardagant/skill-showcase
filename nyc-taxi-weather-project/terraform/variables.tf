variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US 2"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-nyc-taxi-analytics"
}

variable "databricks_workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
  default     = "dbw-nyc-taxi-analytics"
}

variable "databricks_sku" {
  description = "Databricks SKU: trial, standard, or premium"
  type        = string
  default     = "trial"
}