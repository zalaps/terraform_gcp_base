include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//definitions//gke"
}

locals {
  region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

# dependency "k8s-manifest" {
#   config_path = "../k8s-manifest"
#   skip_outputs  = true
# }

inputs = {
  project_id            = local.env.project
  region                = local.region.region
  vpc_main_name         = "some-vpc"
  vpc_sub_name          = "some-sub"
  gke_name              = "some-cluster"
  gke_version           = "1.18.16-gke.2100"
  gke_master_cidr       = "176.16.0.0/28"
  gke_machine_type      = "e2-standard-2"
  gke_disc_size         = 20
  gke_min_count         = 1
  gke_max_count         = 3
  gke_initial_count     = 1
  gke_auto_scale        = true
  gke_nodes_default_sa  = "gke-nodes-default-sa@${local.env.project}.iam.gserviceaccount.com"
  loki_bucket_location  = "EU"
  loki_retention_days   = 90

  gke_master_authorized_networks = [
    { 
      display_name = "some-network", 
      cidr_block   = "w.x.y.z/32" },
  ]
}