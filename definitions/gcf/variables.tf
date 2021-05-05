# General project configuration
variable "project_id" {
  type        = string
  description = "ID of the GCP project that the resources will be deployed in"
}
variable "region" {
  type        = string
  description = "GCP region that the regional resources will be deployed in"
}
variable "prefix" {
  type        = string
  description = "Prefix text which will make resource naming & identification easy"
}

# GCF base needs
variable "bucket_location" {
  type        = string
  description = "Location where bucket would be created"
}
variable "alert_email" {
  type        = string
  description = "Email where failure alerts would be notified"
}
variable "slack_channel_name" {
  type        = string
  description = "Name of Slack channel where failure alert would be delivered"
}
variable "slack_auth_token" {
  type        = string
  description = "Auth token of slack channel to be configured"
}

# gcf configuration
variable "gcf_prefix" {
  type        = string
  description = "Prefix text which will make resource naming & identification easy"
}
variable "gcf_memory" {
  type        = number 
  description = "Memory to be allocated to gcf for execution"
}
variable "gcf_entry_point" {
  type        = string
  description = "The entry method of Google Cloud Function"
}
variable "gcf_runtime" {
  type        = string
  description = "The runtime of Google Cloud Function"
}
variable "gcf_source_path" {
  type        = string
  description = "Local path to source zip"
}
variable "check_timeout" {
  type        = string
  description = "Timeout window to get function call expired"
}
variable "check_period" {
  type        = string
  description = "Interval by which uptime check would be executed"
}
variable "matcher_content" {
  type        = string
  description = "Content to be matched in GCF response"
}
variable "policy_alignment" {
  type        = string
  description = "The alignment period for per-time series alignment"
}
variable "policy_duration" {
  type        = string
  description = "The amount of time that a time series must violate the threshold to be considered failing"
}
variable "policy_threshold" {
  type        = string
  description = "A value against which to compare the time series"
}
variable "policy_trigger_count" {
  type        = string
  description = "The absolute number of time series that must fail the predicate for the condition to be triggered"
}
variable "policy_trigger_percent" {
  type        = string
  description = "The percentage of time series that must fail the predicate for the condition to be triggered"
}