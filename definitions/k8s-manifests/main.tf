data "google_client_config" "provider" {}

provider "kubernetes" {
  host                   = var.gke_endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = var.gke_certificate
}

provider "helm" {
  kubernetes {
    host                   = var.gke_endpoint
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = var.gke_certificate
  }
}
