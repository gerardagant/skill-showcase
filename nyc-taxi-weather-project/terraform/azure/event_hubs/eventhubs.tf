resource "azurerm_eventhub_namespace" "main" {
  name                = "ehns-nyc-taxi-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"   # Standard is required for Kafka protocol support

  capacity = 1

  tags = {
    project    = "nyc-taxi-analytics"
    managed_by = "terraform"
    layer      = "streaming"
  }
}

resource "azurerm_eventhub" "taxi_trips" {
  name                = "taxi-trips"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = 4      # 4 partitions allows 4 parallel Spark tasks
  message_retention   = 1      # Retain events for 1 day (max on Standard free tier)
}

resource "azurerm_eventhub" "weather_events" {
  name                = "weather-events"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_namespace_authorization_rule" "producer" {
  name                = "producer-policy"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name

  listen = false
  send   = true
  manage = false
}

resource "azurerm_eventhub_namespace_authorization_rule" "consumer" {
  name                = "consumer-policy"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name

  listen = true
  send   = false
  manage = false
}
