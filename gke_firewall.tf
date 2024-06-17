# https://docs.prismacloud.io/en/enterprise-edition/policy-reference/google-cloud-policies/google-cloud-networking-policies/bc-gcp-2-18

resource "google_compute_firewall" "testfw" {
  name    = "test-firewall"
  network = google_compute_network.vpc.self_link
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}
