output "storage_bucket_names" {
  description = "Names of the created storage buckets"
  value       = module.storage.bucket_names
}

output "storage_bucket_urls" {
  description = "URLs of the created storage buckets"
  value       = module.storage.bucket_urls
}