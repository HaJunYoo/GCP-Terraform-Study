output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "The self-link of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "subnets" {
  description = "Map of subnet names to their self-links"
  value = {
    for k, v in google_compute_subnetwork.subnets : k => {
      name      = v.name
      self_link = v.self_link
      region    = v.region
      cidr      = v.ip_cidr_range
    }
  }
}
