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
    Application     = "nyc-taxi-analytics"
    environment = "Development"
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
  access_connector_id = azurerm_databricks_access_connector.main.id
}

module "event_hubs" {
  source              = "./azure/event_hubs"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_databricks_access_connector" "main" {
  name                = "dbac-nyc-taxi-analytics"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  identity {
    type = "SystemAssigned"
  }

  tags = {
    project    = "nyc-taxi-analytics"
    managed_by = "terraform"
  }
}

resource "azurerm_role_assignment" "access_connector_storage" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.main.identity[0].principal_id
}

resource "time_sleep" "wait_for_role_propagation" {
  depends_on      = [azurerm_role_assignment.access_connector_storage]
  create_duration = "90s"
}

module "databricks" {
  source       = "./azure/databricks"
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = module.key_vault.tenant_id
  secrets      = local.secrets

  depends_on  = [time_sleep.wait_for_role_propagation]
}

