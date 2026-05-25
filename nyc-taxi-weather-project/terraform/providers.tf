terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0"
      }
      databricks = {
        source  = "databricks/databricks"
        version = "~> 1.40"
      }
      sops = {
        source = "carlpett/sops"
        version = "~> 1.0"
      }
      azuread = {
        source  = "hashicorp/azuread"
        version = "~> 2.0"
      }
    }    
  required_version = ">= 1.3.0"
}

provider "azurerm" {
    subscription_id = local.secrets.subscription_id
    tenant_id       = local.secrets.tenant_id
    features {
        key_vault {
            purge_soft_delete_on_destroy = false
            recover_soft_deleted_key_vaults = true
        }
    }
}

provider "sops" {}

provider "databricks" {
    azure_workspace_resource_id = azurerm_databricks_workspace.this.id
}
