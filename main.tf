resource "google_storage_bucket" "bucket" {
  name     = "testwbkt1"
  location = "europe-west2"
}

resource "google_storage_bucket" "gcs_bucket" {
  name     = "testwbkt2"
  location = "europe-west2"
}