provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "creativedreams-307311-tfstate"
    prefix = "terraform/state"
  }
}