# Billing configuration
variable "billing_account_id" {
  type        = string
  description = "Billing account ID (format: 0123AB-4567CD-8901EF)"
}


variable "base_project_id" {
  type        = string
  description = "Base project ID"
}

# Environment configuration
variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

# Budget configuration
variable "budget_amount" {
  type        = string
  description = "Budget amount (e.g., '100' for $100)"
  default     = "30"
}

variable "currency_code" {
  type        = string
  description = "Currency code (USD, KRW, etc.)"
  default     = "USD"
}

variable "threshold_rules" {
  type = list(object({
    threshold_percent = number
    spend_basis       = string
  }))
  description = "Budget threshold rules for alerts"
  default = [
    {
      threshold_percent = 25
      spend_basis       = "CURRENT_SPEND"
    },
    {
      threshold_percent = 50
      spend_basis       = "CURRENT_SPEND"
    },
    {
      threshold_percent = 75
      spend_basis       = "CURRENT_SPEND"
    },
    {
      threshold_percent = 90
      spend_basis       = "FORECASTED_SPEND"
    },
    {
      threshold_percent = 100
      spend_basis       = "FORECASTED_SPEND"
    }
  ]
}

variable "enable_budget_notifications" {
  type        = bool
  description = "Enable budget notifications"
  default     = true
}

variable "notification_channels" {
  type        = list(string)
  description = "List of notification channels for budget alerts"
  default     = []
}

variable "notification_emails" {
  type        = list(string)
  description = "List of email addresses to receive budget alerts"
}
