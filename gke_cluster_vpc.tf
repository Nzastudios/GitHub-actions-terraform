# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# VPC
resource "google_compute_network" "vpc" {
  name                    = "checkov-dev-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "checkov-dev-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}