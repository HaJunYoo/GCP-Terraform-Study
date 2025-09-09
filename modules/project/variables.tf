variable "project_name" {
  type        = string
  description = "The display name of the project"
}

variable "project_id" {
  type        = string
  description = "The unique project ID"
}

variable "billing_account_id" {
  type        = string
  description = "The billing account ID to associate with the project"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc.)"
}

variable "labels" {
  type        = map(string)
  description = "Additional labels for the project"
  default     = {}
}

variable "apis" {
  type        = list(string)
  description = "List of APIs to enable for the project"
  default = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com"
  ]
}
