# Resource Group
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Databricks Workspace
resource "azurerm_databricks_workspace" "this" {
  name                = var.databricks_workspace_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.databricks_sku

  tags = {
    project     = "nyc-taxi-analytics"
    environment = "dev"
    owner       = "gerard-gant"
  }
}

module "key_vault" {
  source              = "./azure/key_vault"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  secrets             = local.secrets
}

module "storage" {
  source              = "./azure/storage"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

module "event_hubs" {
  source              = "./azure/event_hubs"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

module "databricks" {
  source       = "./azure/databricks"
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = module.key_vault.tenant_id
  secrets      = local.secrets
}
