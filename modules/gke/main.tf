# Service Account for GKE cluster nodes
# Google recommends custom service accounts with minimal required permissions
resource "google_service_account" "gke_sa" {
  account_id   = "${var.cluster_name}-gke-sa"
  display_name = "${var.cluster_name} GKE Service Account"
  project      = var.project_id
}

# IAM roles for GKE service account
# These are the minimal required permissions for GKE nodes
resource "google_project_iam_member" "gke_sa_roles" {
  for_each = toset([
    "roles/logging.logWriter",                  # Write logs to Cloud Logging
    "roles/monitoring.metricWriter",            # Write metrics to Cloud Monitoring
    "roles/monitoring.viewer",                  # Read monitoring data
    "roles/stackdriver.resourceMetadata.writer" # Write resource metadata
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# GKE Private Standard Cluster
# Creates a regional cluster with private nodes and configurable private endpoint
resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region # Regional cluster (not zonal)
  project  = var.project_id

  # Distribute nodes across these zones within the region
  node_locations = var.node_zones

  # We create the smallest possible default node pool and immediately delete it
  # This allows us to manage node pools separately for better flexibility
  remove_default_node_pool = true
  initial_node_count       = 1

  # Network configuration
  network    = var.network    # VPC network self link
  subnetwork = var.subnetwork # Subnet self link

  # Deletion protection (set to false for dev environments)
  deletion_protection = var.deletion_protection

  # Private cluster configuration
  # Private nodes: nodes have private IPs only
  # Private endpoint: master API endpoint is private (typically false for dev)
  private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # IP allocation policy for pods and services
  # Uses secondary IP ranges from the subnet
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name     # For pod IPs
    services_secondary_range_name = var.services_secondary_range_name # For service IPs
  }

  # Master authorized networks - who can access the Kubernetes API
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  # Cluster-level autoscaling configuration
  # Sets resource limits for the entire cluster
  cluster_autoscaling {
    enabled = var.cluster_autoscaling_enabled
    dynamic "resource_limits" {
      for_each = var.cluster_autoscaling_enabled ? var.cluster_autoscaling_resource_limits : []
      content {
        resource_type = resource_limits.value.resource_type # cpu or memory
        minimum       = resource_limits.value.minimum
        maximum       = resource_limits.value.maximum
      }
    }
  }

  # Workload Identity for secure access to GCP services from pods
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # GKE addons configuration
  addons_config {
    # Horizontal Pod Autoscaler (HPA)
    horizontal_pod_autoscaling {
      disabled = !var.horizontal_pod_autoscaling
    }

    # Network policy enforcement
    network_policy_config {
      disabled = !var.network_policy
    }
  }

  # Network policy (requires Calico or similar CNI)
  network_policy {
    enabled = var.network_policy
  }

  # Maintenance window configuration
  dynamic "maintenance_policy" {
    for_each = var.maintenance_start_time != null ? [1] : []
    content {
      daily_maintenance_window {
        start_time = var.maintenance_start_time # HH:MM format (UTC)
      }
    }
  }

  # Resource labels for all cluster resources
  resource_labels = var.resource_labels
}

# GKE Node Pools
# Managed separately from the cluster for better flexibility
# Supports multiple node pools with different configurations
resource "google_container_node_pool" "node_pools" {
  for_each = var.node_pools

  name     = each.key
  location = var.region
  cluster  = google_container_cluster.gke_cluster.name
  project  = var.project_id

  # Initial number of nodes per zone (for regional clusters)
  initial_node_count = each.value.initial_node_count

  # Node pool autoscaling configuration
  autoscaling {
    min_node_count  = each.value.min_node_count  # Minimum nodes per zone
    max_node_count  = each.value.max_node_count  # Maximum nodes per zone
    location_policy = each.value.location_policy # BALANCED, ANY
  }

  # Node management policies
  management {
    auto_repair  = each.value.auto_repair  # Automatically repair unhealthy nodes
    auto_upgrade = each.value.auto_upgrade # Automatically upgrade nodes
  }

  # Node upgrade settings
  upgrade_settings {
    strategy        = each.value.upgrade_strategy # SURGE or BLUE_GREEN
    max_surge       = each.value.max_surge        # Max additional nodes during upgrade
    max_unavailable = each.value.max_unavailable  # Max unavailable nodes during upgrade
  }

  # Node configuration
  node_config {
    # Instance type configuration
    preemptible  = each.value.preemptible  # Preemptible VMs (cheaper, can be terminated)
    spot         = each.value.spot         # Spot VMs (even cheaper, shorter lifespan)
    machine_type = each.value.machine_type # GCE machine type
    disk_size_gb = each.value.disk_size_gb # Boot disk size
    disk_type    = each.value.disk_type    # pd-standard, pd-balanced, pd-ssd
    image_type   = each.value.image_type   # COS_CONTAINERD (recommended)

    # Service account and permissions
    service_account = google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform" # Full GCP API access
    ]

    # Node labels (for scheduling)
    labels = merge(
      var.resource_labels,
      each.value.labels
    )

    # Network tags (for firewall rules)
    tags = each.value.tags

    # Workload Identity metadata configuration
    workload_metadata_config {
      mode = "GKE_METADATA" # Required for Workload Identity
    }

    # Shielded VM configuration for security
    shielded_instance_config {
      enable_secure_boot          = each.value.enable_secure_boot          # Verify boot integrity
      enable_integrity_monitoring = each.value.enable_integrity_monitoring # Monitor runtime integrity
    }

    # Node taints (to repel certain pods)
    dynamic "taint" {
      for_each = each.value.taints
      content {
        key    = taint.value.key    # Taint key
        value  = taint.value.value  # Taint value
        effect = taint.value.effect # NoSchedule, PreferNoSchedule, NoExecute
      }
    }
  }
}
