output "bucket_names" {
  description = "Names of the created buckets"
  value       = google_storage_bucket.buckets[*].name
}

output "bucket_urls" {
  description = "URLs of the created buckets"
  value       = google_storage_bucket.buckets[*].url
}

output "bucket_self_links" {
  description = "Self-links of the created buckets"
  value       = google_storage_bucket.buckets[*].self_link
}