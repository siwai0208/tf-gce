
variable "subnetspub1cidr" {
  type        = string
}
variable "subnetspub2cidr" {
  type        = string
}
variable "subnetsprv1cidr" {
  type        = string
}
variable "subnetsprv2cidr" {
  type        = string
}

resource "google_compute_network" "vpc" {
  name                    = "vpc"
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
}

resource "google_compute_address" "instance-address" {
  name = "instance-address"
}

resource "google_compute_subnetwork" "subnetspub1" {
  name          = "subnetspub1"
  ip_cidr_range = var.subnetspub1cidr
  region        = var.region
  network       = google_compute_network.vpc.name
}

resource "google_compute_subnetwork" "subnetspub2" {
  name          = "subnetspub2"
  ip_cidr_range = var.subnetspub2cidr
  region        = var.region
  network       = google_compute_network.vpc.name
}

resource "google_compute_subnetwork" "subnetsprv1" {
  name          = "subnetsprv1"
  ip_cidr_range = var.subnetsprv1cidr
  region        = var.region
  network       = google_compute_network.vpc.name
}

resource "google_compute_subnetwork" "subnetsprv2" {
  name          = "subnetsprv2"
  ip_cidr_range = var.subnetsprv2cidr
  region        = var.region
  network       = google_compute_network.vpc.name
}
