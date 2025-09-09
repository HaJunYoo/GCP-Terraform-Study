# Provider configuration
terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.38"
    }
  }
}

# Default provider configuration
provider "google" {
  region = "asia-northeast3" # Seoul region
}
