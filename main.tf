resource "google_storage_bucket" "bucket" {
  name     = "workflow-bucket-random-001122-22"
  location = "europe-west2"
}

resource "google_storage_bucket" "gcs_bucket" {
  name     = "workflow-bucket-random-00112323"
  location = "europe-west2"
}