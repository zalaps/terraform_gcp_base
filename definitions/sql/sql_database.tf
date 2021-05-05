resource "google_sql_database" "psql-some-db-app" {
  name      = var.postgres_some-db_db
  instance  = google_sql_database_instance.psql-some-db.name
}
