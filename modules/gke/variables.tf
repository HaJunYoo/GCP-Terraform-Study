variable "project_id" {
  type        = string
  description = "The project ID to deploy the cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "location" {
  type        = string
  description = "Location for the cluster (region or zone)"
}

variable "network" {
  type        = string
  description = "The VPC network to deploy the cluster"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to deploy the cluster"
}

variable "cluster_secondary_range_name" {
  type        = string
  description = "Name of the secondary range for pods"
}

variable "services_secondary_range_name" {
  type        = string
  description = "Name of the secondary range for services"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default     = null
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "enable_private_cluster" {
  type        = bool
  description = "Enable private cluster"
  default     = true
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Enable private endpoint"
  default     = false
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "CIDR block for master nodes"
  default     = "172.16.0.0/28"
}

variable "authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "List of authorized networks"
  default     = []
}

variable "enable_network_policy" {
  type        = bool
  description = "Enable network policy"
  default     = true
}

variable "maintenance_start_time" {
  type        = string
  description = "Maintenance window start time"
  default     = "2023-01-01T09:00:00Z"
}

variable "maintenance_end_time" {
  type        = string
  description = "Maintenance window end time"
  default     = "2023-01-01T17:00:00Z"
}

variable "maintenance_recurrence" {
  type        = string
  description = "Maintenance window recurrence"
  default     = "FREQ=WEEKLY;BYDAY=SA"
}

variable "node_pools" {
  type = map(object({
    node_count      = optional(number, 1)
    machine_type    = optional(string, "e2-medium")
    disk_type       = optional(string, "pd-standard")
    disk_size_gb    = optional(number, 20)
    service_account = optional(string, "default")
    oauth_scopes    = optional(list(string), ["https://www.googleapis.com/auth/cloud-platform"])
    labels          = optional(map(string), {})
    tags            = optional(list(string), [])
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
    auto_repair  = optional(bool, true)
    auto_upgrade = optional(bool, true)
    autoscaling = optional(object({
      min_node_count = number
      max_node_count = number
    }), null)
  }))
  description = "Map of node pools"
  default     = {}
}
