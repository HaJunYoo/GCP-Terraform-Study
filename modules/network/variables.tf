variable "project_id" {
  type        = string
  description = "The project ID to deploy resources"
}

variable "network_name" {
  type        = string
  description = "Name of the VPC network"
}

variable "routing_mode" {
  type        = string
  description = "Network routing mode"
  default     = "REGIONAL"
}

variable "subnets" {
  type = map(object({
    region                   = string
    ip_cidr_range            = string
    private_ip_google_access = optional(bool, true)
    secondary_ranges         = optional(map(string), {})
  }))
  description = "Map of subnets to create"
}

variable "create_default_firewall_rules" {
  type        = bool
  description = "Whether to create default firewall rules"
  default     = true
}
