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

# output "terraform_state_bucket_name" {
#   description = "Name of the Terraform state bucket if created"
#   value       = google_storage_bucket.terraform_state.name
# }
