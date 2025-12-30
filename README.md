# Azure Service Bus Terraform Module

This Terraform module provisions an Azure Service Bus namespace with configurable queues, designed to provide messaging infrastructure with performance-based configurations.

## Features

- **Performance Profiles**: Choose from `sandbox`, `development`, or `production` profiles that automatically map to appropriate Service Bus SKU tiers
- **Queue Creation**: Dynamically create multiple Service Bus queues
- **Flexible Configuration**: Supports Basic, Standard, and Premium tiers
- **Tagged Resources**: Automatic tagging for environment tracking and management

## Performance Profile Mapping

The module automatically maps performance profiles to Azure Service Bus SKU tiers:

| Performance Profile | Service Bus SKU | Description |
|---------------------|-----------------|-------------|
| `sandbox` | Basic | Economic tier for demos and testing |
| `development` | Standard | Supports topics and advanced messaging features |
| `production` | Premium | High performance with VNet support and resource isolation |

## Usage

```hcl
module "service_bus" {
  source = "./tf-azure-servicebus"

  service_name         = "payment-service"
  resource_group_name  = "rg-myapp"
  location             = "eastus"
  performance_profile  = "production"
  queue_names          = ["orders", "notifications", "audit-logs"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Required | Default | Validation |
|------|-------------|------|----------|---------|------------|
| `service_name` | The name of the service (e.g., payment-service). Used for resource naming. | `string` | Yes | - | - |
| `resource_group_name` | The name of the existing Resource Group in Azure. | `string` | Yes | - | - |
| `location` | The Azure region to deploy to. | `string` | Yes | - | - |
| `performance_profile` | The performance tier selected by the developer. | `string` | Yes | - | Must be one of: `sandbox`, `development`, `production` |
| `queue_names` | List of Service Bus queue names to create. | `list(string)` | No | `[]` | - |

## Outputs

| Name | Description |
|------|-------------|
| `namespace_id` | The ID of the Service Bus namespace. |
| `namespace_name` | The name of the Service Bus namespace. |
| `queue_names` | List of created queue names. |

## Resources Created

- `azurerm_servicebus_namespace`: Service Bus namespace with performance-based SKU
- `azurerm_servicebus_queue`: One or more Service Bus queues based on the `queue_names` variable

## Example with Minimal Configuration

```hcl
module "basic_service_bus" {
  source = "./tf-azure-servicebus"

  service_name         = "demo-service"
  resource_group_name  = "rg-sandbox"
  location             = "centralus"
  performance_profile  = "sandbox"
  queue_names          = ["events"]
}
```

## Example with Multiple Environments

```hcl
# Development environment
module "dev_service_bus" {
  source = "./tf-azure-servicebus"

  service_name         = "order-processing"
  resource_group_name  = "rg-dev"
  location             = "westus2"
  performance_profile  = "development"
  queue_names          = ["orders", "shipments"]
}

# Production environment with more queues
module "prod_service_bus" {
  source = "./tf-azure-servicebus"

  service_name         = "order-processing"
  resource_group_name  = "rg-prod"
  location             = "westus2"
  performance_profile  = "production"
  queue_names          = [
    "orders",
    "shipments",
    "notifications",
    "dead-letter",
    "audit-logs"
  ]
}
```

## Service Bus SKU Capabilities

### Basic
- Queues only
- Maximum message size: 256 KB
- Suitable for: Testing, demos, simple messaging scenarios

### Standard
- Queues and topics/subscriptions
- Maximum message size: 256 KB
- Auto-forwarding and scheduled messages
- Suitable for: Development and most production workloads

### Premium
- VNet integration and IP filtering
- Dedicated messaging capacity
- Maximum message size: 1 MB
- Geo-disaster recovery
- Suitable for: Mission-critical production workloads

## Notes

- The Service Bus namespace is named using the pattern: `sb-{service_name}`
- All resources are tagged with environment, managed_by, and service metadata
- Queues are created with default settings; advanced queue configurations can be added by extending the module
- To access Service Bus queues, you'll need to configure connection strings or use Azure Managed Identity

## License

See the main project LICENSE file for details.
