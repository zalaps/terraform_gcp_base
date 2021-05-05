output "bucket_name" {
    value       = local.bucket_name
    description = "The bucket to store GCF source objects"
}

output "email_channel" {
    value       = local.email_channel
    description = "The name of email notification channel"
}
