output "namespace_id" {
  description = "The ID of the Service Bus namespace."
  value       = azurerm_servicebus_namespace.main.id
}

output "namespace_name" {
  description = "The name of the Service Bus namespace."
  value       = azurerm_servicebus_namespace.main.name
}

output "queue_names" {
  description = "List of created queue names."
  value       = [for q in azurerm_servicebus_queue.queues : q.name]
}

output "topic_names" {
  description = "List of created topic names."
  value       = [for t in azurerm_servicebus_topic.topics : t.name]
}
