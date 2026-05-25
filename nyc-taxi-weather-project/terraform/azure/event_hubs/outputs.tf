output "eventhub_namespace_name" {
  description = "Event Hubs namespace name (used as the Kafka bootstrap server hostname)"
  value       = azurerm_eventhub_namespace.main.name
}

output "eventhub_namespace_fqdn" {
  description = "Fully qualified Kafka bootstrap server — use port 9093 for SASL_SSL"
  value       = "${azurerm_eventhub_namespace.main.name}.servicebus.windows.net:9093"
}
