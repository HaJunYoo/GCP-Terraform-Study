variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region for bucket location"
}

variable "bucket_names" {
  type        = list(string)
  description = "List of bucket names to create"
}

variable "storage_class" {
  type        = string
  description = "Storage class for the buckets"
  default     = "STANDARD"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}
