variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

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
}
