# Storage module
module "storage" {
  source = "./modules/storage"

  project_id    = var.project_id
  region        = var.region
  bucket_names  = var.bucket_names
  storage_class = var.storage_class
  environment   = var.environment
}

# Compute module
module "compute" {
  source = "./modules/compute"

  project_id  = var.project_id
  environment = var.environment
  instances   = var.instances
}
