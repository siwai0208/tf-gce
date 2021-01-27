variable "machine_type" {
  type        = string
}
variable "dbuser" {
  type        = string
}
variable "dbpassword" {
  type        = string
}
variable "dbname" {
  type        = string
}
variable "gituser" {
  type        = string
}
variable "gitemail" {
  type        = string
}
variable "gitpassword" {
  type        = string
}
variable "username" {
  type        = string
}
variable "userpass" {
  type        = string
}

data "template_file" "start_config" {
  template = file("./start_config.sh")
  vars = {
    username = var.username
    userpass = var.userpass
    gituser = var.gituser
    gitemail = var.gitemail
    gitpassword = var.gitpassword
    dbname = var.dbname
    dbuser = var.dbuser
    dbpassword = var.dbpassword
  }
}

resource "google_compute_instance" "webserver" {
  name = "webserver"
  machine_type = var.machine_type
  zone = var.zone
  tags = ["allowssh", "allowhttp"]
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-8"
    }
  }

  metadata_startup_script = data.template_file.start_config.rendered
  
  metadata = {
    block-project-ssh-keys = true
    sshKeys = file("./google_compute_engine.pub")
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnetspub1.name
    access_config {
      nat_ip   = google_compute_address.instance-address.address
    }
  }
}

output "instance-ipaddress" {
  value = google_compute_address.instance-address.address
}