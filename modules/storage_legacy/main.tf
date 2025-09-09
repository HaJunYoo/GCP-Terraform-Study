resource "google_storage_bucket" "buckets" {
  count = length(var.bucket_names)

  name          = var.bucket_names[count.index]
  location      = var.region
  storage_class = var.storage_class

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = {
    environment = var.environment
    managed-by  = "terraform"
  }
}

# resource "google_storage_bucket" "terraform_state" {
#   force_destroy = false
#   name          = "${var.project_id}-terraform-bucket"
#   location      = var.region
#   storage_class = "STANDARD"

#   versioning {
#     enabled = true
#   }
# }
