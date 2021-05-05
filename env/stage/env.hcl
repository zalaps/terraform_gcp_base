locals {
  env               = "stage"
#  credentials_path  = "${get_terragrunt_dir()}/credentials.json"
#  credentials       = jsondecode(file(local.credentials_path))
#  service_account   = local.credentials.client_email
  project           = "some-project-123456"
  project_number    = "1234567890"
}