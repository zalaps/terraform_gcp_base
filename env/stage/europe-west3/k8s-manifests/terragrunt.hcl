include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//definitions//k8s-manifests"
}

locals {
  region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

dependency "gke" {
  config_path = "../gke"
#  skip_outputs  = true
}

inputs = {
  project_id                  = local.env.project
  gke_endpoint                = dependency.gke.outputs.gke_cluster_endpoint
  gke_certificate             = dependency.gke.outputs.gke_cluster_certificate_authority_data

  kubernetes_secret_namespace = "default"
  gcp_creds_path              = "./helm/kubernetes-external-secrets/gcp-creds.json"
  external_secret_path        = "./helm/kubernetes-external-secrets/values.yml"

  loki_store_namespace        = "loki-stack"
  loki_store_service_acc      = "loki-stack"
  iam_gservice_account_domain = "iam.gserviceaccount.com"
  loki_path                   = "./helm/loki-chart/values.yml"

  prom_operator_path          = "./helm/prometheus-operator/values.yml"
  prom_push_path              = "./helm/prometheus-pushgateway/values.yml"

  custom_metrics_service_acc  = "custom-metrics-sd-adapter"
  sd_replicas                 = 1
  sd_limits_cpu               = "250m"
  sd_limits_memory            = "200Mi"
  sd_req_cpu                  = "250m"
  sd_req_memory               = "200Mi"
}
