provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "development-337317-tfstate"
    prefix = "terraform/state"
  }
}