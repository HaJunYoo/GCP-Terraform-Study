# Legacy storage and compute modules for existing resources
module "legacy_storage" {
  source = "../../modules/storage_legacy"

  project_id    = var.project_id
  region        = var.region
  bucket_names  = var.bucket_names
  storage_class = var.storage_class
  environment   = var.environment
}

module "legacy_compute" {
  source = "../../modules/compute_legacy"

  project_id  = var.project_id
  environment = var.environment
  instances   = var.instances
}
