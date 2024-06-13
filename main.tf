resource "google_storage_bucket" "bucket" {
  name     = "${var.dev-env}-workflowbucket1"
  location = "europe-west2"
}

resource "google_storage_bucket" "gcs_bucket" {
  name     = "${var.dev-env}-workflowbucket2"
  location = "europe-west2"
}