resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "google_storage_bucket" "buckets" {
  for_each  = var.bucket_list
  name      = "${lower(each.value.name)}-${lower(each.value.location)}-${random_string.random.result}"
  location  = each.value.location
}