# General project configuration
variable "project_id" {
  type        = string
  description = "ID of the GCP project that the resources will be deployed in"
}
variable "region" {
  type        = string
  description = "GCP region that the regional resources will be deployed in"
}

# gce configuration
variable "gce_prefix" {
  type        = string
  description = "Prefix text which will make resource naming & identification easy"
}
variable "gce_main_cidr" {
  type        = string
  description = "IP CIDR range for sub vpc"
}
variable "gce_machine_type" {
  type        = string
  description = "gce machine type"
}
variable "gce_instance_count" {
  type        = number 
  description = "gce instance count"
}
variable "gce_disk_size" {
  type        = number 
  description = "Disk size of gce instance"
}
