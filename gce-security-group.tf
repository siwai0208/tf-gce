variable "sshlocation" {
  type        = string
}
variable "httplocation" {
  type        = string
}

resource "google_compute_firewall" "allowssh" {
    name = "allowssh"
    network = google_compute_network.vpc.name
    allow {
    protocol = "tcp"
    ports    = ["22"]
    }
  source_ranges = [var.sshlocation]
  target_tags = ["allowssh"]
}

resource "google_compute_firewall" "allowhttp" {
    name = "allowhttp"
    network = google_compute_network.vpc.name
    allow {
    protocol = "tcp"
    ports    = ["80"]
    }
  source_ranges = [var.httplocation]
  target_tags = ["allowhttp"]
}
