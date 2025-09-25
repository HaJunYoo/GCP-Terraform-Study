# VPC Network
# Creates a custom VPC with no auto-created subnets for better control
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = var.auto_create_subnetworks
  mtu                     = var.mtu

  # Deletion protection for production environments
  delete_default_routes_on_create = var.delete_default_routes_on_create
}

# Subnet with secondary IP ranges for GKE
# Supports multiple subnets through for_each
resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnets

  name                     = each.key
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  project                  = var.project_id
  network                  = google_compute_network.vpc.id
  private_ip_google_access = each.value.private_ip_google_access

  # Secondary IP ranges for GKE pods and services
  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  # Subnet-level logging (optional)
  dynamic "log_config" {
    for_each = each.value.enable_flow_logs ? [1] : []
    content {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

# Firewall Rules
# Creates multiple firewall rules based on the rules variable
resource "google_compute_firewall" "rules" {
  for_each = var.firewall_rules

  name        = each.key
  network     = google_compute_network.vpc.id
  project     = var.project_id
  description = each.value.description
  direction   = each.value.direction
  priority    = each.value.priority

  # Source ranges (for INGRESS rules)
  source_ranges = each.value.source_ranges

  # Target tags (nodes with these tags will be affected)
  target_tags = each.value.target_tags

  # Allow rules
  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  # Deny rules (if needed)
  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
}

# Cloud Router for NAT Gateway
# Required for private GKE nodes to access the internet
resource "google_compute_router" "router" {
  for_each = var.cloud_routers

  name    = each.key
  network = google_compute_network.vpc.id
  region  = each.value.region
  project = var.project_id

  # BGP configuration (optional)
  dynamic "bgp" {
    for_each = each.value.bgp != null ? [each.value.bgp] : []
    content {
      asn = bgp.value.asn
    }
  }
}

# Cloud NAT Gateway
# Provides internet access for private GKE nodes
resource "google_compute_router_nat" "nat" {
  for_each = var.cloud_nats

  name    = each.key
  router  = google_compute_router.router[each.value.router_name].name
  region  = each.value.region
  project = var.project_id

  # NAT IP allocation
  nat_ip_allocate_option = each.value.nat_ip_allocate_option

  # Source subnetwork configuration
  source_subnetwork_ip_ranges_to_nat = each.value.source_subnetwork_ip_ranges_to_nat

  # Logging configuration
  log_config {
    enable = each.value.enable_logging
    filter = each.value.log_filter
  }

  # Specify NAT IPs if provided (optional)
  nat_ips = each.value.nat_ips
}
