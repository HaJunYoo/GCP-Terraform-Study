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
