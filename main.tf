resource "google_storage_bucket" "bucket" {
  name     = "${var.dev-env}-workflow-bucket-random-1"
  location = "europe-west2"
}

resource "google_storage_bucket" "gcs_bucket" {
  name     = "${var.dev-env}-workflow-bucket-random-2"
  location = "europe-west2"
}