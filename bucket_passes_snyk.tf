resource "google_storage_bucket" "snykbucket" {
  name     = "snyk-bucket-test"
  location = var.region
  project  = var.project_id

  # Versioning block added
  versioning {
    enabled = true
  }

  # We want to protect this bucket. Terraform will not be able to deleted bucket force_destroy = false
  # google_storage_bucket.foo: Error trying to delete a bucket containing objects without `force_destroy` set to true
  # https://github.com/hashicorp/terraform-provider-google/issues/1509

  force_destroy = true

  public_access_prevention = "enforced"

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