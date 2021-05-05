include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//definitions//gcf"
}

locals {
  region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

inputs = {
  project_id            = local.env.project
  region                = local.region.region
  prefix                = join("-", [local.common.global_prefix, local.env.env])

  bucket_location       = "EU"
  alert_email           = "some.one@somedomain.com"
  slack_channel_name    = "#monitoring"
  slack_auth_token      = "some-token"

  gcf_prefix             = "some-function"
  gcf_memory             = 128
  gcf_entry_point        = "main"
  gcf_runtime            = "python38"
  gcf_source_path        = "./source/some-function.zip"
  check_timeout          = "10s"
  check_period           = "300s"
  matcher_content        = "Service is running"
  policy_alignment       = "1200s"
  policy_duration        = "60s"
  policy_threshold       = "1"
  policy_trigger_count   = "1"
  policy_trigger_percent = "0"
}