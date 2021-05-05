variable "project_id" {
  type        = string
  description = "ID of the GCP project that the resources will be deployed in"
}
variable "region" {
  type        = string
  description = "GCP region that the regional resources will be deployed in"
}
variable "vpc_name" {
  type        = string
  description = "Name of the main VPC Network"
}
variable "sub_name" {
  type        = string
  description = "Name of the sub VPC Network"
}
variable "sub_main_cidr" {
  type        = string
  description = "IP range of the subnet to be created in the main VPC"
}
variable "sub_pods_cidr" {
  type        = string
  description = "Secondary IP range of the main VPC that will be allocated for GKE pods addresses"
}
variable "sub_svcs_cidr" {
  type        = string
  description = "Secondary IP range of the main VPC that will be allocated for GKE services addresses"
}