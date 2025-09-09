# VPC Network in network project
module "vpc_network" {
  source = "../../modules/network"

  project_id   = module.network_project.project_id
  network_name = "hj-vpc-dev"

  subnets = {
    "hj-subnet-dev-seoul" = {
      region                   = "asia-northeast3"
      ip_cidr_range            = "10.0.0.0/24"
      private_ip_google_access = true
      secondary_ranges = {
        "gke-pods"     = "10.1.0.0/16"
        "gke-services" = "10.2.0.0/20"
      }
    }
  }

  create_default_firewall_rules = true

  depends_on = [module.network_project]
}
