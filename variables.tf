variable "service_name" {
  description = "The name of the service (e.g., payment-service). Used for resource naming."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the existing Resource Group in Azure."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy to."
  type        = string
}

variable "performance_profile" {
  description = "The performance tier selected by the developer (sandbox, development, production)."
  type        = string

  validation {
    condition     = contains(["sandbox", "development", "production"], var.performance_profile)
    error_message = "Performance profile must be one of: sandbox, development, production."
  }
}

variable "queue_names" {
  description = "List of Service Bus queue names to create."
  type        = list(string)
  default     = []
}

variable "topic_names" {
  description = "List of Service Bus topic names to create."
  type        = list(string)
  default     = []
}
