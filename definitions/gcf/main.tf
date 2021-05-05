locals {
  bucket_name   = google_storage_bucket.bucket.name
  email_channel = google_monitoring_notification_channel.channel01.name
}

resource "random_string" "random_gcf" {
  length  = 6
  special = false
  upper   = false
}

resource "google_storage_bucket" "bucket" {
  name      = "${var.prefix}-source-bucket-${random_string.random_gcf.result}"
  location  = var.bucket_location
}

resource "google_monitoring_notification_channel" "channel01" {
  display_name  = "${var.prefix}-email-notification-channel"
  type          = "email"
  project       = var.project_id
  labels        = {
    email_address = var.alert_email
  }
}

# resource "google_monitoring_notification_channel" "channel02" {
#   display_name  = "${var.prefix}-slack-notification-channel"
#   type          = "slack"
#   project       = var.project_id
#   labels        = {
#     channel_name = var.slack_channel_name
#   }
#   sensitive_labels {
#     auth_token = var.slack_auth_token
#   }
# }

resource "google_storage_bucket_object" "archive01" {
  name   = "${var.gcf_prefix}.zip"
  bucket = google_storage_bucket.bucket.name
  source = var.gcf_source_path
}

resource "google_cloudfunctions_function" "function01" {
  name                  = "${var.gcf_prefix}-function"
  project               = var.project_id
  region                = var.region
  description           = "${var.gcf_prefix}-function"
  runtime               = var.gcf_runtime
  available_memory_mb   = var.gcf_memory
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive01.name
  trigger_http          = true
  entry_point           = var.gcf_entry_point
}

resource "google_cloudfunctions_function_iam_member" "invoker01" {
  project         = google_cloudfunctions_function.function01.project
  region          = google_cloudfunctions_function.function01.region
  cloud_function  = google_cloudfunctions_function.function01.name
  role            = "roles/cloudfunctions.invoker"
  member          = "allUsers"
}

resource "google_monitoring_uptime_check_config" "check01" {
  display_name    = "${var.gcf_prefix}-uptime-check"
  timeout         = var.check_timeout
  period          = var.check_period
  http_check {
    path          = "/${var.gcf_prefix}-function"
  }
  monitored_resource {
    type          = "uptime_url"
    labels        = {
      project_id  = var.project_id
      host        = trimprefix(trimsuffix(google_cloudfunctions_function.function01.https_trigger_url, "/${var.gcf_prefix}-function"), "https://")
    }
  }
  content_matchers {
    content       = var.matcher_content
  }
}

resource "google_monitoring_alert_policy" "policy01" {
  combiner              = "OR"
  display_name          = "${var.gcf_prefix}-alert-policy"
  enabled               = "true"
  notification_channels = [google_monitoring_notification_channel.channel01.name]
  project               = var.project_id
  conditions {
    condition_threshold {
      aggregations {
        alignment_period     = var.policy_alignment
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.*"]
        per_series_aligner   = "ALIGN_NEXT_OLDER"
      }
      comparison      = "COMPARISON_GT"
      duration        = var.policy_duration
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.check01.uptime_check_id}\" AND resource.type=\"uptime_url\""
      threshold_value = var.policy_threshold
      trigger {
        count   = var.policy_trigger_count
        percent = var.policy_trigger_percent
      }
    }
    display_name = "${var.gcf_prefix}-alert-policy-condition"
  }  
}