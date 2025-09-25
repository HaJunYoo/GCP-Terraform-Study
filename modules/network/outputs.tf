output "network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "network_self_link" {
  description = "Self link of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "subnets" {
  description = "Map of subnet information"
  value = {
    for k, subnet in google_compute_subnetwork.subnets : k => {
      id                  = subnet.id
      self_link           = subnet.self_link
      name                = subnet.name
      ip_cidr_range       = subnet.ip_cidr_range
      region              = subnet.region
      gateway_address     = subnet.gateway_address
      secondary_ip_ranges = subnet.secondary_ip_range
    }
  }
}

output "subnet_ids" {
  description = "IDs of the subnets"
  value       = { for k, subnet in google_compute_subnetwork.subnets : k => subnet.id }
}

output "subnet_self_links" {
  description = "Self links of the subnets"
  value       = { for k, subnet in google_compute_subnetwork.subnets : k => subnet.self_link }
}

output "firewall_rule_ids" {
  description = "IDs of the firewall rules"
  value       = { for k, rule in google_compute_firewall.rules : k => rule.id }
}

output "router_ids" {
  description = "IDs of the Cloud Routers"
  value       = { for k, router in google_compute_router.router : k => router.id }
}

output "nat_ids" {
  description = "IDs of the Cloud NAT gateways"
  value       = { for k, nat in google_compute_router_nat.nat : k => nat.id }
}

# Convenience outputs for single subnet scenarios
output "first_subnet_id" {
  description = "ID of the first subnet (convenience for single subnet scenarios)"
  value       = length(google_compute_subnetwork.subnets) > 0 ? values(google_compute_subnetwork.subnets)[0].id : null
}

output "first_subnet_self_link" {
  description = "Self link of the first subnet (convenience for single subnet scenarios)"
  value       = length(google_compute_subnetwork.subnets) > 0 ? values(google_compute_subnetwork.subnets)[0].self_link : null
}
