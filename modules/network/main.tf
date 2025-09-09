# VPC Network
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

# Subnets
resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnets

  name          = each.key
  project       = var.project_id
  network       = google_compute_network.vpc.name
  region        = each.value.region
  ip_cidr_range = each.value.ip_cidr_range

  # Secondary IP ranges for GKE
  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ranges", {})
    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }

  private_ip_google_access = lookup(each.value, "private_ip_google_access", true)
}

# Firewall rules
resource "google_compute_firewall" "allow_internal" {
  count = var.create_default_firewall_rules ? 1 : 0

  name    = "${var.network_name}-allow-internal"
  project = var.project_id
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [for subnet in var.subnets : subnet.ip_cidr_range]
}

resource "google_compute_firewall" "allow_ssh" {
  count = var.create_default_firewall_rules ? 1 : 0

  name    = "${var.network_name}-allow-ssh"
  project = var.project_id
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}
