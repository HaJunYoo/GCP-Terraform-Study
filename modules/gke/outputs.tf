output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.gke_cluster.name
}

output "cluster_id" {
  description = "ID of the GKE cluster"
  value       = google_container_cluster.gke_cluster.id
}

output "cluster_location" {
  description = "Location (region) of the GKE cluster"
  value       = google_container_cluster.gke_cluster.location
}

output "cluster_endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = google_container_cluster.gke_cluster.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "CA certificate of the GKE cluster"
  value       = google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_master_version" {
  description = "Master version of the GKE cluster"
  value       = google_container_cluster.gke_cluster.master_version
}

output "cluster_node_locations" {
  description = "Node locations of the GKE cluster"
  value       = google_container_cluster.gke_cluster.node_locations
}

output "service_account_email" {
  description = "Email of the GKE service account"
  value       = google_service_account.gke_sa.email
}

output "service_account_name" {
  description = "Name of the GKE service account"
  value       = google_service_account.gke_sa.name
}

output "node_pool_ids" {
  description = "IDs of the node pools"
  value       = { for k, v in google_container_node_pool.node_pools : k => v.id }
}

output "node_pool_versions" {
  description = "Versions of the node pools"
  value       = { for k, v in google_container_node_pool.node_pools : k => v.version }
}

output "node_pool_instance_group_urls" {
  description = "Instance group URLs of the node pools"
  value       = { for k, v in google_container_node_pool.node_pools : k => v.instance_group_urls }
}
