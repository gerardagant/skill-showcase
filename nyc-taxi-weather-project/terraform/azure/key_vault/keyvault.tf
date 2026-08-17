data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = "kv-nyc-taxi-analytics"   # Must be globally unique, 3-24 chars
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = {
    project     = "nyc-taxi-analytics"
    managed_by  = "terraform"
    secret_source = "sops"
  }
}

resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge", "Recover"
  ]
}