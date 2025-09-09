# GKE Cluster
resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.location

  # Network configuration
  network    = var.network
  subnetwork = var.subnetwork

  # IP allocation for pods and services
  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  # Initial node pool (will be removed after creating managed node pools)
  remove_default_node_pool = true
  initial_node_count       = 1

  # Cluster configuration
  min_master_version = var.kubernetes_version

  # Private cluster configuration
  dynamic "private_cluster_config" {
    for_each = var.enable_private_cluster ? [1] : []
    content {
      enable_private_nodes    = true
      enable_private_endpoint = var.enable_private_endpoint
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }
  }

  # Master authorized networks
  dynamic "master_authorized_networks_config" {
    for_each = length(var.authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Logging and monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Addons
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    network_policy_config {
      disabled = !var.enable_network_policy
    }
  }

  # Network policy
  network_policy {
    enabled = var.enable_network_policy
  }

  # Maintenance policy
  maintenance_policy {
    recurring_window {
      start_time = var.maintenance_start_time
      end_time   = var.maintenance_end_time
      recurrence = var.maintenance_recurrence
    }
  }
}

# Node Pool
resource "google_container_node_pool" "node_pools" {
  for_each = var.node_pools

  name     = each.key
  project  = var.project_id
  cluster  = google_container_cluster.cluster.name
  location = var.location

  node_count = lookup(each.value, "node_count", 1)

  # Autoscaling
  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", null) != null ? [each.value.autoscaling] : []
    content {
      min_node_count = autoscaling.value.min_node_count
      max_node_count = autoscaling.value.max_node_count
    }
  }

  # Node configuration
  node_config {
    machine_type = lookup(each.value, "machine_type", "e2-medium")
    disk_type    = lookup(each.value, "disk_type", "pd-standard")
    disk_size_gb = lookup(each.value, "disk_size_gb", 20)

    # Service account
    service_account = lookup(each.value, "service_account", "default")
    oauth_scopes = lookup(each.value, "oauth_scopes", [
      "https://www.googleapis.com/auth/cloud-platform"
    ])

    # Metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }

    # Labels
    labels = merge(
      {
        environment = var.environment
        managed-by  = "terraform"
      },
      lookup(each.value, "labels", {})
    )

    # Taints
    dynamic "taint" {
      for_each = lookup(each.value, "taints", [])
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    # Tags
    tags = concat(
      ["gke-node", var.cluster_name],
      lookup(each.value, "tags", [])
    )
  }

  # Management
  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", true)
  }
}
