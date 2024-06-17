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
