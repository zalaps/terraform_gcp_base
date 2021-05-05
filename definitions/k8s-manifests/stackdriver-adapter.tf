resource "kubernetes_service_account" "custom_metrics_stackdriver_adapter" {
  metadata {
    name        = "custom-metrics-stackdriver-adapter"
    namespace   = "monitoring"
    annotations = {
      "iam.gke.io/gcp-service-account" = "${var.custom_metrics_service_acc}@${var.project_id}.iam.gserviceaccount.com"
    }
  }
}

resource "kubernetes_cluster_role_binding" "custom_metrics_system_auth_delegator" {
  metadata {
    name = "custom-metrics:system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "custom-metrics-stackdriver-adapter"
    namespace = "monitoring"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator" 
  }
}

resource "kubernetes_role_binding" "custom_metrics_auth_reader" {
  metadata {
    name      = "custom-metrics-auth-reader"
    namespace = "kube-system"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "custom-metrics-stackdriver-adapter"
    namespace = "monitoring"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader" 
  }
}

resource "kubernetes_cluster_role_binding" "custom_metrics_resource_reader" {
  metadata {
    name = "custom-metrics-resource-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "custom-metrics-stackdriver-adapter"
    namespace = "monitoring"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"  
  }
}

resource "kubernetes_deployment" "custom_metrics_stackdriver_adapter" {
  metadata {
    name      = "custom-metrics-stackdriver-adapter"
    namespace = "monitoring"
    labels = {
      k8s-app = "custom-metrics-stackdriver-adapter"
      run     = "custom-metrics-stackdriver-adapter"
    }
  }
  spec {
    replicas = var.sd_replicas
    selector {
      match_labels = {
        k8s-app = "custom-metrics-stackdriver-adapter"
        run     = "custom-metrics-stackdriver-adapter"
      }
    }
    template {
      metadata {
        labels = {
          k8s-app                         = "custom-metrics-stackdriver-adapter"
          "kubernetes.io/cluster-service" = "true"
          run                             = "custom-metrics-stackdriver-adapter"
        }
      }
      spec {
        container {
          name    = "pod-custom-metrics-stackdriver-adapter"
          image   = "gcr.io/gke-release/custom-metrics-stackdriver-adapter:v0.12.0-gke.0"
          command = ["/adapter", "--use-new-resource-model=true"]
          resources {
            limits = {
              cpu    = var.sd_limits_cpu
              memory = var.sd_limits_memory
            }
            requests = {
              cpu    = var.sd_req_cpu
              memory = var.sd_req_memory
            }
          }
          image_pull_policy = "IfNotPresent"
          volume_mount {
            name       = kubernetes_service_account.custom_metrics_stackdriver_adapter.default_secret_name
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            read_only  = true
          }
        }
        service_account_name = "custom-metrics-stackdriver-adapter"
        volume {
          name = kubernetes_service_account.custom_metrics_stackdriver_adapter.default_secret_name

          secret {
            secret_name = kubernetes_service_account.custom_metrics_stackdriver_adapter.default_secret_name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "custom_metrics_stackdriver_adapter" {
  metadata {
    name      = "custom-metrics-stackdriver-adapter"
    namespace = "monitoring"
    labels = {
      k8s-app                         = "custom-metrics-stackdriver-adapter"
      "kubernetes.io/cluster-service" = "true"
      "kubernetes.io/name"            = "Adapter"
      run                             = "custom-metrics-stackdriver-adapter"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 443
      target_port = "443"
    }
    selector = {
      k8s-app = "custom-metrics-stackdriver-adapter"
      run     = "custom-metrics-stackdriver-adapter"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_api_service" "v_1_beta_1_custom_metrics_k_8_s_io" {
  metadata {
    name = "v1beta1.custom.metrics.k8s.io"
  }
  spec {
    service {
      name      = "custom-metrics-stackdriver-adapter"
      namespace = "monitoring"
    }
    group                    = "custom.metrics.k8s.io"
    version                  = "v1beta1"
    insecure_skip_tls_verify = true
    group_priority_minimum   = 100
    version_priority         = 100
  }
}

resource "kubernetes_api_service" "v_1_beta_2_custom_metrics_k_8_s_io" {
  metadata {
    name = "v1beta2.custom.metrics.k8s.io"
  }
  spec {
    service {
      name      = "custom-metrics-stackdriver-adapter"
      namespace = "monitoring"
    }
    group                    = "custom.metrics.k8s.io"
    version                  = "v1beta2"
    insecure_skip_tls_verify = true
    group_priority_minimum   = 100
    version_priority         = 200
  }
}

resource "kubernetes_api_service" "v_1_beta_1_external_metrics_k_8_s_io" {
  metadata {
    name = "v1beta1.external.metrics.k8s.io"
  }
  spec {
    service {
      name      = "custom-metrics-stackdriver-adapter"
      namespace = "monitoring"
    }
    group                    = "external.metrics.k8s.io"
    version                  = "v1beta1"
    insecure_skip_tls_verify = true
    group_priority_minimum   = 100
    version_priority         = 100
  }
}

resource "kubernetes_cluster_role" "external_metrics_reader_role" {
  metadata {
    name = "external-metrics-reader"
  }
  rule {
    verbs      = ["list", "get", "watch"]
    api_groups = ["external.metrics.k8s.io"]
    resources  = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "external_metrics_reader_binding" {
  metadata {
    name = "external-metrics-reader"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "horizontal-pod-autoscaler"
    namespace = "kube-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "external-metrics-reader"
  }
  depends_on = [ kubernetes_cluster_role.external_metrics_reader_role ]
}