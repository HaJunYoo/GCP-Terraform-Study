# Project outputs
output "network_project_id" {
  description = "Network project ID"
  value       = module.network_project.project_id
}

output "infrastructure_project_id" {
  description = "Infrastructure project ID"
  value       = module.infrastructure_project.project_id
}

# Network outputs
output "vpc_network_name" {
  description = "VPC network name"
  value       = module.vpc_network.network_name
}

output "subnets" {
  description = "Created subnets"
  value       = module.vpc_network.subnets
}

# GKE outputs
output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = module.gke_cluster.cluster_name
}

output "gke_cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = module.gke_cluster.cluster_endpoint
  sensitive   = true
}

# Legacy outputs
output "legacy_storage_bucket_names" {
  description = "Names of the created storage buckets (legacy)"
  value       = module.legacy_storage.bucket_names
}

output "legacy_compute_instance_names" {
  description = "Names of the created compute instances (legacy)"
  value       = module.legacy_compute.instance_names
}
