resource "random_password" "psql_user_some-db_pwd" {
  length           = 16
  special          = true
}

locals {
  local_password = random_password.psql_user_some-db_pwd.result
}

resource "google_sql_user" "psql-user-some-db" {
  name        = var.postgres_user
  instance    = google_sql_database_instance.psql-some-db.name
  password    = local.local_password
  depends_on  = [ google_sql_database_instance.psql-some-db ]
}

output "psql_user_some-db_password" {
  value = local.local_password
}