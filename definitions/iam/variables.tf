variable "project_id" {
  type        = string
  description = "ID of the GCP project that the resources will be deployed in"
}

# service accounts
variable "service_accounts" {
  type = map(object({
    id    = string
    desc  = string
  }))
}

variable "iam_policy_dataset" {
  type = map(object({
    users = list(string)
    roles = list(string)
  }))
}

variable "sa_iam_members" {
  type = map(object({
    sa_id   = string
    role    = string
    member  = string
  }))
}