# Network project
module "network_project" {
  source = "../../modules/project"

  project_name       = "HJ Network Hub Dev"
  project_id         = "hj-network-hub-dev"
  billing_account_id = var.billing_account_id
  environment        = "dev"

  labels = {
    role   = "network-hub"
    region = "seoul"
  }

  apis = [
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "dns.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

# Infrastructure project
module "infrastructure_project" {
  source = "../../modules/project"

  project_name       = "HJ Infrastructure Dev"
  project_id         = "hj-infra-dev"
  billing_account_id = var.billing_account_id
  environment        = "dev"

  labels = {
    role   = "application-infrastructure"
    region = "seoul"
  }

  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com"
  ]
}
