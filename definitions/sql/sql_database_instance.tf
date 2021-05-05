resource "google_sql_database_instance" "some-db" {
  name             = "some-db01"
  database_version = var.postgres_version

  settings {
    tier = var.postgres_tier

    disk_autoresize = var.postgres_disk_autoresize
    disk_size       = var.postgres_disk_size
    disk_type       = var.postgres_disk_type

    activation_policy = "ALWAYS"
    availability_type = "ZONAL"

    location_preference {
      zone = var.zone
    }

    ip_configuration {
      authorized_networks {
        name  = "some network"
        value = var.office_egress_subnet
      }

      ipv4_enabled = "true"
      require_ssl  = "false"
    }

    backup_configuration {
      binary_log_enabled             = "false"
      enabled                        = "false"
      location                       = "eu"
      point_in_time_recovery_enabled = "false"
      start_time                     = "23:00"
    }

    #maintenance_window {
    #  day  = "0"
    #  hour = "0"
    #}
  }
}
