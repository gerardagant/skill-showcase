resource "azurerm_key_vault_secret" "sp_client_id" {
  name         = "sp-client-id"
  value        = var.secrets["sp_client_id"]
  key_vault_id = azurerm_key_vault.main.id

  tags = { managed_by = "terraform-sops" }
}

resource "azurerm_key_vault_secret" "sp_client_secret" {
  name         = "sp-client-secret"
  value        = var.secrets["sp_client_secret"]
  key_vault_id = azurerm_key_vault.main.id

  tags = { managed_by = "terraform-sops" }
}

resource "azurerm_key_vault_secret" "storage_account_key" {
  name         = "storage-account-key"
  value        = var.secrets["storage_account_key"]
  key_vault_id = azurerm_key_vault.main.id

  tags = { managed_by = "terraform-sops" }
}

resource "azurerm_key_vault_secret" "openweathermap_api_key" {
  name         = "openweathermap-api-key"
  value        = var.secrets["owm_api_key"]
  key_vault_id = azurerm_key_vault.main.id

  tags = { managed_by = "terraform-sops" }
}
