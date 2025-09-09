variable "billing_account_id" {
  type        = string
  description = "The billing account ID"
}

variable "budget_display_name" {
  type        = string
  description = "The display name of the budget"
}

variable "projects" {
  type        = list(string)
  description = "List of project IDs to apply budget to"
  default     = []
}

variable "services" {
  type        = list(string)
  description = "List of service names to include in budget"
  default     = []
}

variable "credit_types_treatment" {
  type        = string
  description = "Credit types treatment (INCLUDE_ALL_CREDITS, EXCLUDE_ALL_CREDITS, INCLUDE_SPECIFIED_CREDITS)"
  default     = "INCLUDE_ALL_CREDITS"
}

variable "currency_code" {
  type        = string
  description = "The currency code (e.g., USD, KRW)"
  default     = "USD"
}

variable "budget_amount" {
  type        = string
  description = "The budget amount"
}

variable "threshold_rules" {
  type = list(object({
    threshold_percent = number
    spend_basis       = string # CURRENT_SPEND or FORECASTED_SPEND
  }))
  description = "Threshold rules for budget alerts"
  default = [
    {
      threshold_percent = 50
      spend_basis       = "CURRENT_SPEND"
    },
    {
      threshold_percent = 90
      spend_basis       = "CURRENT_SPEND"
    },
    {
      threshold_percent = 100
      spend_basis       = "FORECASTED_SPEND"
    }
  ]
}

variable "enable_all_updates_rule" {
  type        = bool
  description = "Whether to enable all updates rule for notifications"
  default     = true
}

variable "pubsub_topic" {
  type        = string
  description = "Pub/Sub topic for budget notifications"
  default     = null
}

variable "schema_version" {
  type        = string
  description = "Schema version for notifications"
  default     = "1.0"
}

variable "monitoring_notification_channels" {
  type        = list(string)
  description = "List of monitoring notification channels"
  default     = []
}

variable "disable_default_iam_recipients" {
  type        = bool
  description = "Whether to disable default IAM recipients"
  default     = false
}
