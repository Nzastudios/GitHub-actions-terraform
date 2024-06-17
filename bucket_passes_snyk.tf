resource "google_storage_bucket" "snykbucket" {
  name     = "snyk-bucket-test"
  location = var.region
  project  = var.project_id

  # Versioning block added
  versioning {
    enabled = true
  }

  # Ensure public access prevention is enforced
  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-general-policies/bc-google-cloud-114
  public_access_prevention = "enforced"

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
