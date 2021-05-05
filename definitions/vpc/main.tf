locals {
  vpc_name      = google_compute_network.some-vpc.name
  vpc_sub_name  = google_compute_subnetwork.some-sub.name
}

resource "google_compute_network" "some-vpc" {
    auto_create_subnetworks         = false
    delete_default_routes_on_create = false
    mtu                             = 0
    name                            = var.vpc_name
    project                         = var.project_id
    routing_mode                    = "GLOBAL"
}

resource "google_compute_subnetwork" "some-sub" {
    ip_cidr_range               = var.sub_main_cidr
    name                        = var.sub_name
    network                     = google_compute_network.some-vpc.name
    private_ip_google_access    = true
    #private_ipv6_google_access  = "DISABLE_GOOGLE_ACCESS"
    project                     = var.project_id
    secondary_ip_range          = [
        {
            "ip_cidr_range" : var.sub_pods_cidr,
            "range_name"    : "${var.project_id}-vpc-pods"
        },
        {
            "ip_cidr_range" : var.sub_svcs_cidr,
            "range_name"    : "${var.project_id}-vpc-svcs"
        }
    ]
}

resource "random_string" "name_suffix" {
    length  = 6
    lower   = true
    number  = true
    special = false
    upper   = false
}

resource "google_compute_router" "router" {
    bgp  {
        advertise_mode  = "DEFAULT"
        asn             = 64514
    }
    name    = "some-nat-rtr"
    network = google_compute_network.some-vpc.name
    project = var.project_id
}

resource "google_compute_router_nat" "main" {
    name                                = "some-nat"
    nat_ip_allocate_option              = "AUTO_ONLY"    
    project                             = var.project_id
    router                              = google_compute_router.router.name
    source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"    
    min_ports_per_vm                    = 64
}