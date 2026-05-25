output "key_vault_name" {
  value = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  value = module.key_vault.key_vault_uri
}

output "key_vault_id" {
  value = module.key_vault.key_vault_id
}

# Useful for creating the Databricks secret scope (Step 8)
output "databricks_secret_scope_config" {
  value = {
    resource_id = module.key_vault.key_vault_id
    dns_name    = module.key_vault.key_vault_uri
  }
}

output "databricks_workspace_url" {
  description = "URL to access the Databricks workspace"
  value       = azurerm_databricks_workspace.this.workspace_url
}

output "databricks_workspace_id" {
  description = "Resource ID of the Databricks workspace"
  value       = azurerm_databricks_workspace.this.id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.this.name
}
