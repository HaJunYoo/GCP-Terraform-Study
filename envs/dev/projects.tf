# dev project
module "dev_project" {
  source = "../../modules/project"

  project_name       = "HJ Dev Environment"
  project_id         = "hj-dev-project"
  billing_account_id = var.billing_account_id
  environment        = "dev"

  labels = {
    role   = "full-stack-dev"
    region = "seoul"
  }

  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "dns.googleapis.com",
    "servicenetworking.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudtrace.googleapis.com",
    "containerregistry.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}
