resource "kubernetes_namespace" "loki" {
  metadata {
    name = var.loki_store_namespace
  }
}

resource "kubernetes_service_account" "loki_store_k8s_sa" {
  metadata {
    name        = var.loki_store_service_acc
    namespace   = var.loki_store_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = "${var.loki_store_service_acc}@${var.project_id}.${var.iam_gservice_account_domain}"
    }
  }
  depends_on    = [ kubernetes_namespace.loki ]
}

resource "helm_release" "loki-stack" {
  name       = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = "loki-stack"
  version    = var.loki_stack_version
  values = [
    file(var.loki_path)
  ]
  depends_on = [ kubernetes_service_account.loki_store_k8s_sa ]
}

### prometheus operator ###
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus-operator" {
   name       = "prometheus-operator"
   repository = "https://prometheus-community.github.io/helm-charts"
   chart      = "kube-prometheus-stack"
   namespace  = "monitoring"
   version    = var.prometheus_operator_version
   values = [
     file(var.prom_operator_path)
   ] 
   depends_on = [kubernetes_namespace.monitoring]
}

### prometheus pushgateway ###
resource "helm_release" "prometheus-pushgateway" {
  name       = "prometheus-pushgateway"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-pushgateway"
  namespace  = "monitoring"
  version    = var.prometheus_pushgateway_version
  values = [
    file(var.prom_push_path)
  ]
  depends_on  = [kubernetes_namespace.monitoring]
}

### prodigy plugin ###
resource "kubernetes_service_account" "grafana_prodigy_sa" {
  metadata {
    name = "grafana-kubegraf"
  }
  secret {
    name = "grafana-kubegraf-secret"
  }
}

resource "kubernetes_secret" "grafana_prodigy_secret" {
  metadata {
    name = "grafana-kubegraf-secret"
    annotations = {
      "kubernetes.io/service-account.name" = "grafana-kubegraf"
    }
  }
  lifecycle {
    ignore_changes = [data]
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_cluster_role" "grafana_prodigy_cluster_role" {
  metadata {
    name = "grafana-kubegraf"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "services", "componentstatuses", "nodes", "events"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["deployments", "daemonsets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets", "deployments", "daemonsets"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "grafana_prodigy_cluster_role_binding" {
  metadata {
    name = "grafana-kubegraf"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "grafana-kubegraf"
  }
  subject {
    kind     = "User"
    name     = "grafana-kubegraf"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "grafana-kubegraf"
    namespace = "default"
  }
}