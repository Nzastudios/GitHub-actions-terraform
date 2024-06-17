resource "google_storage_bucket" "snykbucket" {
  name     = "snyk-bucket-test"
  location = var.region
  project  = var.project_id

  # Versioning block added
  versioning {
    enabled = true
  }

  # We want to protect this bucket. It should NEVER be deleted.
  force_destroy = false

  uniform_bucket_level_access = true

  encryption {
    default_kms_key_name = ""
  }
  lifecycle { ignore_changes = [encryption] }

  # Added versioning enabled block

  # Adding loggin block
  logging {
    log_bucket = "snyklogx"
  }

}
