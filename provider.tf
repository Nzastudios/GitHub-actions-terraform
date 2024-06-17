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

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.78"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.82"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.4"
    }
  }
}