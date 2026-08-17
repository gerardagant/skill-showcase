terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

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

resource "databricks_cluster_policy" "cost_controlled" {
  name = "nyc-taxi-cost-controlled"

  definition = jsonencode({
    "autotermination_minutes" : {
      "type"    : "range",
      "maxValue": 30,
      "defaultValue": 15
    },
    "node_type_id" : {
      "type"    : "allowlist",
      "values"  : [data.databricks_node_type.smallest.id]
    }
  })
}

resource "databricks_permissions" "cluster_usage" {
  cluster_id = databricks_cluster.shared_single_node.id

  access_control {
    group_name       = "users"
    permission_level = "CAN_RESTART"
  }
}

resource "databricks_cluster" "shared_single_node" {
  cluster_name            = "nyc-taxi-analytics"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  policy_id               = databricks_cluster_policy.cost_controlled.id
  autotermination_minutes = 15
  is_single_node          = true
  kind                    = "CLASSIC_PREVIEW"
  data_security_mode      = "SINGLE_USER"
}