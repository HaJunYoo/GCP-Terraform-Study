# Billing configuration
variable "billing_account_id" {
  type        = string
  description = "Billing account ID (format: 0123AB-4567CD-8901EF)"
}

# Legacy variables (for existing resources)
variable "project_id" {
  type        = string
  description = "The existing GCP project ID for legacy resources"
}

variable "region" {
  type        = string
  description = "The GCP region"
  default     = "asia-northeast3" # Seoul region
}

variable "zone" {
  type        = string
  description = "The GCP zone"
  default     = "asia-northeast3-a" # Seoul zone
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

# Legacy storage variables
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

# Legacy compute variables
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
