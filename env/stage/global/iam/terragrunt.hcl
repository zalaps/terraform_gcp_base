include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//definitions//iam"
}

locals {
  env                                = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common                             = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
  project_number                     = local.env.project_number
  service_account_suffix             = "gserviceaccount.com"
  iam_gcp_default_account_suffix     = "iam.${local.service_account_suffix}"
  iam_common_service_account_suffix  = "${local.env.project}.${local.iam_gcp_default_account_suffix}"
}

inputs = {
  project_id = local.env.project

  service_accounts = {
    "grafana"                        = { id  = "grafana", desc = "Google Cloud Monitoring datasource for Grafana" }
    "db-sa-user"                     = { id  = "db-sa-user", desc = "Account for Cloud SQL" }
    "loki-stack"                     = { id  = "loki-stack", desc= "Service account for accessing/storing Loki data to GCS bucket" }
    "custom-metrics-sd-adapter"      = { id  = "custom-metrics-sd-adapter", desc= "For custom metric stack driver access purpose" }
    "gke-nodes-default-sa"           = { id  = "gke-nodes-default-sa", desc= "Default service account used for k8s nodes" }
    "secret-manager-service-account" = { id  = "secret-manager-service-account", desc= "For secret-manger in k8s" }
  }

  sa_iam_members = {
    "loki-stack" = {
      sa_id   = "projects/${local.env.project}/serviceAccounts/loki-stack@${local.iam_common_service_account_suffix}",
      role    = "roles/iam.workloadIdentityUser",
      member  = "serviceAccount:${local.env.project}.svc.id.goog[loki-stack/loki-stack]"
    }
    "custom-metrics-sd-adapter" = {
      sa_id   = "projects/${local.env.project}/serviceAccounts/custom-metrics-sd-adapter@${local.iam_common_service_account_suffix}",
      role    = "roles/iam.workloadIdentityUser",
      member  = "serviceAccount:${local.env.project}.svc.id.goog[monitoring/custom-metrics-stackdriver-adapter]"
    }
  }

  iam_policy_dataset = {
    "owners" = {
      users = ["user:some.user@somedomain.com"]
      roles = ["roles/owner"]
    }

    "developers" = {
      users = [
        "user:some.dev1@somedomain.com",
        "user:some.dev2@somedomain.com"
      ]
      roles = ["roles/editor"]
    }

    "monitoring_viewer" = {
      users = [ "serviceAccount:grafana@${local.iam_common_service_account_suffix}"]
      roles = ["roles/monitoring.viewer"]
    }

    "monitoring_editors" = {
      users = ["serviceAccount:custom-metrics-sd-adapter@${local.iam_common_service_account_suffix}"]
      roles = ["roles/monitoring.editor"]
    }

    "storage_admin" = {
      users = ["serviceAccount:loki-stack@${local.iam_common_service_account_suffix}"]
      roles = ["roles/storage.admin"]
    }

    "sql_client" = {
      users = ["serviceAccount:db-sa-user@${local.iam_common_service_account_suffix}"]
      roles = ["roles/cloudsql.client"]
    }

    "gke_nodes_default_sa" = {
      users = ["serviceAccount:gke-nodes-default-sa@${local.iam_common_service_account_suffix}"]
      roles = [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/monitoring.viewer",
        "roles/stackdriver.resourceMetadata.writer",
        "roles/iam.workloadIdentityUser"
      ]
    }

    "secret-manager-service-account" = {
      users = ["serviceAccount:secret-manager-service-account@${local.iam_common_service_account_suffix}"]
      roles = [
        "roles/secretmanager.secretAccessor",
        "roles/secretmanager.viewer"
      ]
    }
  }
}