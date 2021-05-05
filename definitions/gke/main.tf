module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                    = "~> 12.3.0"
  project_id                 = var.project_id
  name                       = var.gke_name
  kubernetes_version         = var.gke_version
  region                     = var.region
  zones                      = ["${var.region}-a", "${var.region}-b", "${var.region}-c"]
  network                    = var.vpc_main_name
  subnetwork                 = var.vpc_sub_name
  network_policy             = true
  ip_range_pods              = "${var.vpc_main_name}-pods"
  ip_range_services          = "${var.vpc_main_name}-svcs"
  enable_private_nodes       = true
  master_ipv4_cidr_block     = var.gke_master_cidr
  remove_default_node_pool   = true
  initial_node_count         = 1
  master_authorized_networks = var.gke_master_authorized_networks 
  create_service_account     = false
  service_account            = var.gke_nodes_default_sa

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = var.gke_machine_type
      disk_size_gb       = var.gke_disc_size
      initial_node_count = var.gke_initial_count
      autoscaling        = var.gke_auto_scale
      min_count          = var.gke_min_count
      max_count          = var.gke_max_count
    }
  ]
  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/logging.write",
    ]
  }
}

output "gke_cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with the cluster"
  value       = base64decode(module.gke.ca_certificate)
  sensitive   = true
}

output "gke_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = module.gke.endpoint
  sensitive   = true
}