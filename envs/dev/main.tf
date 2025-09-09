# Provider configuration
terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  backend "gcs" {
    bucket = "hj-gcp-terraform-bucket"
    prefix = "terraform/envs/dev"
  }
}

# Default provider configuration
provider "google" {
  region                = "asia-northeast3" # Seoul region
  user_project_override = true
  billing_project       = var.base_project_id
}
