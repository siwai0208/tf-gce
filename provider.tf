variable "gcp_project" {
  type        = string
}
variable "region" {
  type        = string
}
variable "zone" {
  type        = string
}

provider "google" {
  project = var.gcp_project
  region  = var.region
  zone    = var.zone
}
