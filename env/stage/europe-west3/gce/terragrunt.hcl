include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//definitions//gce"
}

locals {
  region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

inputs = {
  project_id          = local.env.project
  region              = local.region.region

  gce_prefix         = "gce"
  gce_main_cidr      = "10.2.1.0/24"
  gce_machine_type   = "g1-small"
  gce_instance_count = 1
  gce_disk_size      = 30
}