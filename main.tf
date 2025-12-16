# Map performance profiles to Service Bus SKU tiers
locals {
  sku_map = {
    sandbox     = "Basic"     # Economic tier for demos/testing
    development = "Standard"  # Supports topics and advanced features
    production  = "Premium"   # High performance with VNet support
  }
}

# Create Service Bus Namespace
resource "azurerm_servicebus_namespace" "main" {
  name                = "sb-${var.service_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = local.sku_map[var.performance_profile]

  tags = {
    environment = var.performance_profile
    managed_by  = "terraform"
    service     = var.service_name
  }
}

# Create Service Bus Queues
resource "azurerm_servicebus_queue" "queues" {
  for_each = toset(var.queue_names)

  name         = each.value
  namespace_id = azurerm_servicebus_namespace.main.id
}
