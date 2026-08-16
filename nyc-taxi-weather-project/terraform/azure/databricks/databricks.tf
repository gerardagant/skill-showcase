terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

# resource "azurerm_databricks_workspace" "main" {
#   name                = "dbw-nyc-taxi-analytics"
#   resource_group_name = azurerm_resource_group.this.name
#   location            = azurerm_resource_group.this.location
#   sku                 = "premium"

#   tags = {
#     Application  = "nyc-taxi-analytics"
#     managed_by   = "terraform"
    
#   }

#   lifecycle {
#     prevent_destroy = true
#   }

# }

resource "databricks_token" "main" {
  comment          = "Terraform-managed token for automation"
  lifetime_seconds = 31536000  # 1 year — rotate via terraform apply
}

resource "azurerm_key_vault_secret" "databricks_token" {
  name         = "databricks-token"
  value        = databricks_token.main.token_value
  key_vault_id = var.key_vault_id

  tags = { managed_by = "terraform" }
}

data "azuread_service_principal" "databricks" {
  display_name = "AzureDatabricks"
}

resource "azurerm_key_vault_access_policy" "databricks" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = data.azuread_service_principal.databricks.object_id

  secret_permissions = ["Get", "List"]
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "shared_single_node" {
  cluster_name             = "nyc-taxi-analytics"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 15
  is_single_node          = true
  kind                    = "CLASSIC_PREVIEW"
  data_security_mode      = "SINGLE_USER"

}