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

# Compute Engine variables
variable "instances" {
  type = map(object({
    name                   = string
    machine_type           = string
    zone                   = string
    image                  = optional(string, "debian-cloud/debian-12")
    disk_size              = optional(number, 10)
    network                = optional(string, "default")
    subnetwork             = optional(string, null)
    enable_public_ip       = optional(bool, true)
    tags                   = optional(list(string), [])
    labels                 = optional(map(string), {})
    metadata               = optional(map(string), {})
    service_account_email  = optional(string, "default")
    service_account_scopes = optional(list(string), ["cloud-platform"])
  }))
  description = "Map of compute instances to create"
  default     = {}
}
