resource "google_storage_bucket" "example_bucket" {
  name                        = "snyk-bucket-test"
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true
  logging {
    log_bucket = "snyklogx"
  }

  public_access_prevention = "enforced"

}
