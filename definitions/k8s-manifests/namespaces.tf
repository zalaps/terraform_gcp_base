resource "kubernetes_namespace" "development" {
  metadata {
    name = "development"
  }
}

resource "kubernetes_namespace" "tools" {
  metadata {
    name = "tools"
  }
}