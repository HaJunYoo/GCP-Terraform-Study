output "storage_bucket_names" {
  description = "Names of the created storage buckets"
  value       = module.storage.bucket_names
}

output "storage_bucket_urls" {
  description = "URLs of the created storage buckets"
  value       = module.storage.bucket_urls
}

output "compute_instance_names" {
  description = "Names of the created compute instances"
  value       = module.compute.instance_names
}

output "compute_instance_external_ips" {
  description = "External IP addresses of the created compute instances"
  value       = module.compute.instance_external_ips
}

output "compute_instance_internal_ips" {
  description = "Internal IP addresses of the created compute instances"
  value       = module.compute.instance_internal_ips
}
