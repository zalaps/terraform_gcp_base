variable "project_id" {
  type        = string
  description = "ID of the GCP project that the resources will be deployed in"
}

variable "region" {
  type        = string
  description = "GCP region that the regional resources will be deployed in"
}

variable "vpc_main_name" {
  type        = string
  description = "Name of network"
}

variable "vpc_sub_name" {
  type        = string
  description = "Name of subnet"
}


variable "gke_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "gke_version" {
  type        = string
  description = "The Kubernetes version of the masters."
}

variable "gke_master_cidr" {
  type        = string
  description = "Master CIDR for GKE cluster"
}

variable "gke_master_authorized_networks" {
  type        = list(object({ display_name = string, cidr_block = string}))
  description = "List of IP ranges that will have access to a GKE Master API public endpoint"
}

variable "gke_machine_type" {
  type        = string
  description = "Machine type of GKE Nodes"
}

variable "gke_disc_size" {
  type        = number
  description = "Disc size in GB for GKE nodes"
}

variable "gke_min_count" {
  type        = number
  description = "Minimum number of nodes to be sustained in GKE"
}

variable "gke_max_count" {
  type        = number
  description = "Maximum number of nodes per zone GKE can auto scale to"
}

variable "gke_initial_count" {
  type        = number
  description = "Initial number of nodes per zone GKE can start with"
}

variable "gke_auto_scale" {
  type        = bool
  description = "Defines whether GKE cluster can auto scale nodes"
}

variable "gke_nodes_default_sa" {
  type        = string
  description = "Default SA for k8s nodes"
}

# loki
variable "loki_bucket_location" {
  type        = string
  description = "Location where bucket would be created"
}

variable "loki_retention_days" {
  type    = number
}