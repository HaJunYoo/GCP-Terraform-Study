# GKE Cluster in infrastructure project
module "gke_cluster" {
  source = "../../modules/gke"

  project_id   = module.infrastructure_project.project_id
  cluster_name = "hj-gke-dev"
  location     = "asia-northeast3-a"

  network    = module.vpc_network.network_self_link
  subnetwork = module.vpc_network.subnets["hj-subnet-dev-seoul"].self_link

  cluster_secondary_range_name  = "gke-pods"
  services_secondary_range_name = "gke-services"

  environment = "dev"

  enable_private_cluster  = true
  enable_private_endpoint = false
  master_ipv4_cidr_block  = "172.16.0.0/28"

  authorized_networks = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "All networks (dev environment)"
    }
  ]

  node_pools = {
    "default-pool" = {
      node_count   = 2
      machine_type = "e2-medium"
      disk_size_gb = 20
      autoscaling = {
        min_node_count = 1
        max_node_count = 5
      }
      labels = {
        pool = "default"
      }
      tags = ["dev", "gke-node"]
    }
  }

  depends_on = [module.infrastructure_project, module.vpc_network]
}
