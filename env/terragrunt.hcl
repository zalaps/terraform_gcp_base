locals {
  # Load any configured variables
  region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

# Configure Terragrunt to store state in GCP buckets
remote_state {
  backend = "gcs"

  config = {
    bucket      = "${local.env.project}-terragrunt-state"
    prefix      = "${path_relative_to_include()}"
    location    = local.region.region
    project     = local.env.project
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.45.0"
    }
    google-beta = {
      source  = "hashicorp/google"
      version = "~> 3.45.0"
    }
  }
}

provider "google" {
  project     = "${local.env.project}"
  region      = "${local.region.region}"
}

# For access to Google Beta features
provider "google-beta" {
  project     = "${local.env.project}"
  region      = "${local.region.region}"
}

provider "random" {
}
  EOF
}

inputs = merge(
  local.region,
  local.env,
  local.common,
)