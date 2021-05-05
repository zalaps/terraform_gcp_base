include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//definitions//vpc"       
}

locals {
  region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

inputs = {
  project_id    = local.env.project   
  region        = local.region
  vpc_name      = "some-vpc"
  sub_name      = "some-sub"
  sub_main_cidr = "10.2.0.0/24"
  sub_pods_cidr = "192.168.16.0/21"
  sub_svcs_cidr = "192.168.24.0/21"
}