resource "azurerm_storage_account" "datalake" {
  name                     = "stnyctaxianalytics"   # Must be globally unique, 3-24 lowercase alphanumeric
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"                  # LRS is sufficient for a dev/portfolio project

  # Hierarchical namespace = ADLS Gen2
  is_hns_enabled = true

  # Enforce HTTPS — never allow plain HTTP
  https_traffic_only_enabled = true

  # Minimum TLS version for all connections
  min_tls_version = "TLS1_2"

  tags = {
    project    = "nyc-taxi-analytics"
    managed_by = "terraform"
    layer      = "storage"
  }
}

resource "time_sleep" "wait_for_dfs_propagation" {
  depends_on        = [azurerm_storage_account.datalake]
  create_duration = "90s"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "raw" {
  name               = "raw"
  storage_account_id = azurerm_storage_account.datalake.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "bronze" {
  name               = "bronze"
  storage_account_id = azurerm_storage_account.datalake.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "silver" {
  name               = "silver"
  storage_account_id = azurerm_storage_account.datalake.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gold" {
  name               = "gold"
  storage_account_id = azurerm_storage_account.datalake.id
}

# resource "azurerm_role_assignment" "databricks_sp_storage" {
#   scope                = azurerm_storage_account.datalake.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = local.secrets.sp_client_id
# }
