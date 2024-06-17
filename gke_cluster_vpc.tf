# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# VPC
resource "google_compute_network" "vpc" {
  name                    = "checkov-dev-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
# https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-general-policies/ensure-gcp-subnet-has-a-private-ip-google-access
# Enabling private IP Google access
resource "google_compute_subnetwork" "subnet" {
  name                     = "checkov-dev-subnet"
  region                   = var.region
  network                  = google_compute_network.vpc.name
  ip_cidr_range            = "10.10.0.0/24"
  private_ip_google_access = true

  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-networking-policies/ensure-gcp-private-google-access-is-enabled-for-ipv6
  # Enabling Private Google Access for IPv6 can help improve the security
  private_ipv6_google_access = "ENABLE_BIDIRECTIONAL_ACCESS_TO_GOOGLE"

  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/logging-policies-1/bc-gcp-logging-1
  # Enable VPC Flow logs for the subnet
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}