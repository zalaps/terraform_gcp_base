variable "project_id" {
  type        = string
  description = "ID of the GCP project that the resources will be deployed in"
}

variable "bucket_list" {
  type = map(object({
    name = string
    location = string
  }))
}