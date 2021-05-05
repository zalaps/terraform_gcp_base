include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//definitions//sql"
}

locals {
  region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

inputs = {
  zone                      = local.region.zone
  office_egress_subnet      = "w.x.y.z/32"
  postgres_version          = "POSTGRES_9_6"
  postgres_user             = "postgres"
  postgres_some-db_db       = "some-db"
  postgres_tier             = "db-custom-4-16384"
  postgres_disk_autoresize  = "false"
  postgres_disk_size        = 50
  postgres_disk_type        = "PD_SSD"
}