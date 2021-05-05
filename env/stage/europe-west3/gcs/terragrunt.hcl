include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//definitions//gcs"
}

locals {
  env                     = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common                  = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
  default_bucket_location = "EU"
}

inputs = {
  project_id      = local.env.project
  bucket_list     = {
    "some-bucket-1" = { name = "some-bucket-1", location = "${local.default_bucket_location}" }
    "some-bucket-2" = { name = "some-bucket-2", location = "${local.default_bucket_location}" }
  }
}