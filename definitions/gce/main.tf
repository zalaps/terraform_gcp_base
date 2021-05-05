resource "google_compute_network" "gce-vpc" {
    auto_create_subnetworks         = false
    delete_default_routes_on_create = false
    mtu                             = 1460
    name                            = "${var.gce_prefix}-vpc"
    project                         = var.project_id
    routing_mode                    = "GLOBAL"
}

resource "google_compute_subnetwork" "gce-sub" {
    ip_cidr_range               = var.gce_main_cidr
    name                        = "${var.gce_prefix}-sub"
    network                     = google_compute_network.gce-vpc.name
    private_ip_google_access    = true
    project                     = var.project_id
}

# Public IP address for vm
resource "google_compute_address" "gce_ip" {
  region  = var.region
  project = var.project_id
  name    = "${var.gce_prefix}-ip"
}

module "gce_vm" {
  source                    = "github.com/terraform-google-modules/cloud-foundation-fabric/modules/compute-vm"
  project_id                = var.project_id
  region                    = var.region
  name                      = "${var.gce_prefix}-01"
  instance_type             = var.gce_machine_type
  network_interfaces        = [{
    network    = google_compute_network.gce-vpc.self_link
    subnetwork = google_compute_subnetwork.gce-sub.self_link
    nat        = true
    addresses  = {
      internal = []
      external = [ google_compute_address.gce_ip.address ]
    }
    alias_ips  = null
  }]
  service_account_create    = false
  instance_count            = var.gce_instance_count
  tags                      = ["http-server","node-exporter"]
  boot_disk = {
    image   = "projects/debian-cloud/global/images/family/debian-10"
    type    = "pd-standard"
    size    = var.gce_disk_size
  }
}

# firewalls
resource "google_compute_firewall" "gce_allow_http" {
  project       = var.project_id
  name          = "${var.gce_prefix}-allow-http"
  network       = google_compute_network.gce-vpc.self_link
  target_tags   = ["http-server"]
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = [80]
  }
}

resource "google_compute_firewall" "gce_allow_node_exporter" {
  project       = var.project_id
  name          = "${var.gce_prefix}-allow-node-exporter"
  network       = google_compute_network.gce-vpc.self_link
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["10.0.0.0/24"]
  target_tags   = ["node-exporter"]

  allow {
    protocol = "tcp"
    ports    = [9100]
  }
}
