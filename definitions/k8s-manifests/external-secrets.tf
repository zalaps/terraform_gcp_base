# "./helm/kubernetes-external-secrets/gcp-creds.json"
# "./helm/kubernetes-external-secrets/values.yml"

resource "kubernetes_secret" "gcp-creds" {
  metadata {
    name = "gcp-creds"
    namespace = var.kubernetes_secret_namespace
  }
  data = {
    "gcp-creds.json" =  file(var.gcp_creds_path)
  }
}

resource "helm_release" "external-secrets" {
  name       = "external-secrets"
  repository = "https://external-secrets.github.io/kubernetes-external-secrets/"
  chart      = "kubernetes-external-secrets"
  namespace  = var.kubernetes_secret_namespace
  version    = var.kubernetes_external_secrets_version
  values = [
    file(var.external_secret_path)
  ]
  depends_on = [ kubernetes_secret.gcp-creds ]
}
