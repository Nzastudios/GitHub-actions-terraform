locals {
  prd_dbc_secrets = var.organization == "nzastudios.com" ? ["corelight-lic-key","jpmorgan-pwd"] : []
}

resource "google_secret_manager_secret" "license-secret" {
  for_each = toset(local.prd_dbc_secrets)
  provider = google-beta
  project         = var.project_id
  secret_id       = each.value

  #   labels = {
  #   label = "snyk-secret-label"
  # }

#   rotation {
#     rotation_period = "7776000s"
#     next_rotation_time = ""
#   }

  replication {
    user_managed {
      replicas {
        location = "europe-west2"
      }
    }
  }
}

# Grant a user or service account IAM permissions to access the Corelight license secret:
resource "google_secret_manager_secret_iam_member" "access-license-secret" {
  for_each = google_secret_manager_secret.license-secret
  provider = google-beta
  project   = each.value.project
  secret_id = each.value.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:terraform-jenkins@development-337317.iam.gserviceaccount.com" # or serviceAccount:my-app@...
}
