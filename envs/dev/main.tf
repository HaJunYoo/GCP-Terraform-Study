# Backend configuration for dev environment
terraform {
  backend "gcs" {
    bucket = "hj-gcp-terraform-bucket"
    prefix = "terraform/envs/dev"
  }
}
