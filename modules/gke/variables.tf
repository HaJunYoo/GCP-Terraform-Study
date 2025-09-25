variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "GCP region for the cluster"
  type        = string
}

variable "node_zones" {
  description = "List of zones where GKE nodes will be located"
  type        = list(string)
  default     = []
}

variable "network" {
  description = "VPC network self link"
  type        = string
}

variable "subnetwork" {
  description = "VPC subnetwork self link"
  type        = string
}

variable "deletion_protection" {
  description = "Enable deletion protection for the cluster"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for the cluster master"
  type        = bool
  default     = false
}

variable "enable_private_nodes" {
  description = "Enable private nodes for the cluster"
  type        = bool
  default     = true
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the master network"
  type        = string
}

variable "pods_secondary_range_name" {
  description = "Name of the secondary range for pods"
  type        = string
}

variable "services_secondary_range_name" {
  description = "Name of the secondary range for services"
  type        = string
}

variable "master_authorized_networks" {
  description = "List of master authorized networks"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [{
    cidr_block   = "0.0.0.0/0"
    display_name = "entire-internet"
  }]
}

variable "cluster_autoscaling_enabled" {
  description = "Enable cluster autoscaling"
  type        = bool
  default     = true
}

variable "cluster_autoscaling_resource_limits" {
  description = "Resource limits for cluster autoscaling"
  type = list(object({
    resource_type = string
    minimum       = number
    maximum       = number
  }))
  default = [
    {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 100
    },
    {
      resource_type = "memory"
      minimum       = 1
      maximum       = 1000
    }
  ]
}

variable "horizontal_pod_autoscaling" {
  description = "Enable horizontal pod autoscaling"
  type        = bool
  default     = true
}

variable "network_policy" {
  description = "Enable network policy"
  type        = bool
  default     = false
}

variable "maintenance_start_time" {
  description = "Start time for maintenance window (HH:MM format)"
  type        = string
  default     = "02:00"
}

variable "resource_labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default = {
    managed-by = "terraform"
  }
}

variable "node_pools" {
  description = "Map of node pool configurations"
  type = map(object({
    initial_node_count          = optional(number, 1)
    min_node_count              = optional(number, 1)
    max_node_count              = optional(number, 3)
    location_policy             = optional(string, "BALANCED")
    auto_repair                 = optional(bool, true)
    auto_upgrade                = optional(bool, true)
    upgrade_strategy            = optional(string, "SURGE")
    max_surge                   = optional(number, 1)
    max_unavailable             = optional(number, 0)
    preemptible                 = optional(bool, false)
    spot                        = optional(bool, false)
    machine_type                = optional(string, "e2-medium")
    disk_size_gb                = optional(number, 20)
    disk_type                   = optional(string, "pd-standard")
    image_type                  = optional(string, "COS_CONTAINERD")
    labels                      = optional(map(string), {})
    tags                        = optional(list(string), [])
    enable_secure_boot          = optional(bool, false)
    enable_integrity_monitoring = optional(bool, true)
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
  default = {}
}
