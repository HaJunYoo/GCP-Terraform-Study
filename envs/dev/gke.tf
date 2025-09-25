data "google_compute_zones" "available" {
  project = module.dev_project.project_id
  region  = var.gcp_region
  status  = "UP"
}

locals {
  name = "hj-${var.environment}"
}

# Network Module
module "network" {
  source = "../../modules/network"

  project_id   = module.dev_project.project_id
  network_name = "${local.name}-vpc"

  subnets = {
    "${local.name}-${var.gcp_region}-subnet" = {
      ip_cidr_range            = var.subnet_ip_range[0]
      region                   = var.gcp_region
      private_ip_google_access = true
      secondary_ip_ranges = [
        {
          range_name    = "kubernetes-pod-range"
          ip_cidr_range = var.pods_ip_range
        },
        {
          range_name    = "kubernetes-services-range"
          ip_cidr_range = var.services_ip_range
        }
      ]
    }
  }

  firewall_rules = {
    "${local.name}-fwrule-allow-ssh22" = {
      description   = "Allow SSH access"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["ssh-tag"]
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
    }
  }

  cloud_routers = {
    "${local.name}-${var.gcp_region}-cloud-router" = {
      region = var.gcp_region
    }
  }

  cloud_nats = {
    "${local.name}-${var.gcp_region}-cloud-nat" = {
      router_name    = "${local.name}-${var.gcp_region}-cloud-router"
      region         = var.gcp_region
      enable_logging = true
      log_filter     = "ALL"
    }
  }
}

# GKE Module
module "gke_cluster" {
  source = "../../modules/gke"

  project_id   = module.dev_project.project_id
  cluster_name = "${local.name}-gke-cluster"
  region       = var.gcp_region
  node_zones   = ["asia-northeast3-b"] # Restrict to single zone

  network    = module.network.network_self_link
  subnetwork = module.network.first_subnet_self_link

  deletion_protection     = false
  enable_private_endpoint = false
  enable_private_nodes    = true
  master_ipv4_cidr_block  = var.master_ip_range

  pods_secondary_range_name     = "kubernetes-pod-range"
  services_secondary_range_name = "kubernetes-services-range"

  master_authorized_networks = var.master_authorized_networks

  cluster_autoscaling_enabled = true
  horizontal_pod_autoscaling  = true
  network_policy              = false
  maintenance_start_time      = "02:00"

  resource_labels = {
    environment = var.environment
    managed-by  = "terraform"
  }

  node_pools = {
    "linux-nodepool-1" = {
      initial_node_count = 1
      min_node_count     = 1
      max_node_count     = 3
      location_policy    = "BALANCED"

      auto_repair  = true
      auto_upgrade = true

      preemptible  = true
      machine_type = "e2-small"
      disk_size_gb = 20
      disk_type    = "pd-standard"

      labels = {
        nodepool = "linux-nodepool-1"
      }

      tags = ["ssh-tag"]
    }
  }
}

# Outputs
output "network_id" {
  description = "VPC network ID"
  value       = module.network.network_id
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = module.network.subnet_ids
}

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = module.gke_cluster.cluster_name
}

output "gke_cluster_location" {
  description = "GKE Cluster location"
  value       = module.gke_cluster.cluster_location
}

output "gke_cluster_endpoint" {
  description = "GKE Cluster Endpoint"
  value       = module.gke_cluster.cluster_endpoint
  sensitive   = true
}

output "gke_cluster_master_version" {
  description = "GKE Cluster master version"
  value       = module.gke_cluster.cluster_master_version
}
