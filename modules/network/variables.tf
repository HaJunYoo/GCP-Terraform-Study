variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "auto_create_subnetworks" {
  description = "Whether to auto-create subnetworks"
  type        = bool
  default     = false
}

variable "mtu" {
  description = "Maximum Transmission Unit in bytes"
  type        = number
  default     = 1460
}

variable "delete_default_routes_on_create" {
  description = "Whether to delete default routes on VPC creation"
  type        = bool
  default     = false
}

variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    ip_cidr_range            = string
    region                   = string
    private_ip_google_access = optional(bool, true)
    enable_flow_logs         = optional(bool, false)
    secondary_ip_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
  default = {}
}

variable "firewall_rules" {
  description = "Map of firewall rule configurations"
  type = map(object({
    description   = optional(string, "")
    direction     = string # INGRESS or EGRESS
    priority      = optional(number, 1000)
    source_ranges = optional(list(string), [])
    target_tags   = optional(list(string), [])
    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])
  }))
  default = {}
}

variable "cloud_routers" {
  description = "Map of Cloud Router configurations"
  type = map(object({
    region = string
    bgp = optional(object({
      asn = number
    }), null)
  }))
  default = {}
}

variable "cloud_nats" {
  description = "Map of Cloud NAT configurations"
  type = map(object({
    router_name                        = string
    region                             = string
    nat_ip_allocate_option             = optional(string, "AUTO_ONLY")
    source_subnetwork_ip_ranges_to_nat = optional(string, "ALL_SUBNETWORKS_ALL_IP_RANGES")
    enable_logging                     = optional(bool, true)
    log_filter                         = optional(string, "ALL")
    nat_ips                            = optional(list(string), [])
  }))
  default = {}
}
