### prometheus operator ###
# there is an issue with PO -> https://github.com/prometheus-operator/prometheus-operator/issues/2711
resource "google_compute_firewall" "gke-master-to-kubelet" {
  name      = "k8s-master-to-kubelets"
  network   = var.vpc_main_name
  project   = var.project_id

  description = "GKE master to kubelets"

  source_ranges = [var.gke_master_cidr]

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }
}

### loki ###
resource "google_storage_bucket" "loki_storage" {
  name      = "${var.project_id}-loki-logs" 
  location  = var.loki_bucket_location
  project   = var.project_id
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age                = var.loki_retention_days
      num_newer_versions = 0
      with_state         = "ANY"
    }
  }
}