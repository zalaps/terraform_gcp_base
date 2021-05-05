#sa creation
resource "google_service_account" "sa" {
  for_each      = var.service_accounts
  account_id    = each.value.id
  description   = each.value.desc
  display_name  = each.value.id
  project       = var.project_id
}

#sa key generation
resource "google_service_account_key" "sa_key" {
  for_each            = var.service_accounts
  depends_on          = [ google_service_account.sa ]
  service_account_id  = "projects/${var.project_id}/serviceAccounts/${each.value.id}@${var.project_id}.iam.gserviceaccount.com"
}

#mapping sa-key tuple to object
locals {
  key_values = flatten([
    for k in google_service_account_key.sa_key : {
        keyname = base64decode(k.private_key)
      }
  ])
}

#printing private keys to output
output "service_account_keys" {
  value = local.key_values
}

locals {    
  association-list = flatten([
    for i in var.iam_policy_dataset : [
      for r in i.roles : {
        members = i.users
        role    = r
      }
    ]
  ])
}

#policy data
data "google_iam_policy" "gip01" {
  dynamic "binding" {
    for_each = local.association-list
    content {
      role      = binding.value.role
      members   = binding.value.members
    }
  }
}

resource "google_project_iam_policy" "gpip01" {
  project     = var.project_id
  policy_data = data.google_iam_policy.gip01.policy_data
  depends_on  = [google_service_account.sa]
}

resource "google_service_account_iam_member" "gsaim01" {
  for_each            = var.sa_iam_members
  service_account_id  = each.value.sa_id
  role                = each.value.role
  member              = each.value.member
  depends_on          = [google_service_account.sa]
}