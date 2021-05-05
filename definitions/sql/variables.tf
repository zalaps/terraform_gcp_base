# General project configuration
variable "zone" {
  type        = string
  description = "GCP zone that the regional resources will be deployed in"
}

variable "office_egress_subnet" {
  description = "A CIDR notation IPv4 or IPv6 address that is allowed to access this instance"
  type        = string
}

variable "postgres_version" {
  type        = string
  description = "Postgres version"
}

variable "postgres_user" {
  type        = string
  description = "User to DB"
}

# variable "postgres_user_password" {
#   type        = string
# }

variable "postgres_some-db_db" {
  type        = string
  description = "Name of knowledge base database"
}

variable "postgres_tier" {
  type        = string
  description = "The machine type to use"
}

variable "postgres_disk_autoresize" {
  type        = string
  description = "Configuration to increase storage size automatically"
}

variable "postgres_disk_size" {
  type        = number
  description = "The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased"
}

variable "postgres_disk_type" {
  type        = string
  description = "The type of data disk: PD_SSD or PD_HDD"
}



