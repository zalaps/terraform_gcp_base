variable "project_id" {
  type        = string
  description = "ID of the GCP project that the resources will be deployed in"
}

# external secrets
variable "kubernetes_secret_namespace" {
  type        = string
  description = "Name of namespace for kubernetes secret"
}

variable "gke_endpoint" {
  type        = string
  description = "Endpoint to the GKE cluster"
}

variable "gke_certificate" {
  type        = string
  description = "Certificate of the GKE cluster"
}

variable "gcp_creds_path" {
  type        = string
  description = "Path of gcp-creds file"
}

variable "external_secret_path" {
  type        = string
  description = "Path of values.yml for external secrets"
}

# loki
variable "loki_store_namespace" {
  type        = string
  description = "Name of the service account for storing Loki data"
}

variable "loki_store_service_acc" {
  type        = string
  description = "Name of the service account for storing Loki data"
}

variable "iam_gservice_account_domain" {
  type        = string
  description = "Domain of google IAM service account"
}

variable "loki_path" {
  type        = string
  description = "Path of values.yml for loki"
}

# prometheus
variable "prom_operator_path" {
  type        = string
  description = "Path of values.yml for prometheus operator"
}

variable "prom_push_path" {
  type        = string
  description = "Path of values.yml for prometheus push gateway"
}

# custom stack driver adaptor
variable "custom_metrics_service_acc" {
  type        = string
  description = "Memory value for resources request"
}

variable "sd_replicas" {
  type        = number
  description = "Number of replicas of stackdriver adapter to be generated"
}   

variable "sd_limits_cpu" {
  type        = string
  description = "CPU value for resources limit"
}   

variable "sd_limits_memory" {
  type        = string
  description = "Memory value for resources limit"
}   

variable "sd_req_cpu" {
  type        = string
  description = "CPU value for resources request"
}   

variable "sd_req_memory" {
  type        = string
  description = "Memory value for resources request"
}

variable "prometheus_pushgateway_version" {
  type        = string
  description = "Version of Prometheus-pushgateway Helm chart"
  default     = "1.8.0"
}

variable "prometheus_operator_version" {
  type        = string
  description = "Version of Prometheus-operator Helm chart"
  default     = "14.9.0"
}

variable "loki_stack_version" {
  type        = string
  description = "Version of Loki Helm chart"
  default     = "2.3.1"
}

variable "kubernetes_external_secrets_version" {
  type        = string
  description = "Version of Kubernetes external secrets Helm chart"
  default     = "6.4.0"
}
