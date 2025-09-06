variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region"
  default     = "asia-northeast3" # Seoul region
}

variable "terraform_state_bucket" {
  type        = string
  description = "The GCP bucket name for storing Terraform state"
}

variable "zone" {
  type        = string
  description = "The GCP zone"
  default     = "asia-northeast3-a" # Seoul zone
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
}

# Storage specific variables
variable "bucket_names" {
  type        = list(string)
  description = "List of bucket names to create"
  default     = []
}

variable "storage_class" {
  type        = string
  description = "Storage class for buckets"
  default     = "STANDARD"
}
