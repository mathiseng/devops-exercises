terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.34.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.34.0"
    }
  }
}


provider "google" {
  project     = var.project_id
  credentials = var.sa_key_name
  region      = var.region
  zone        = var.zone
}

# To allow SSH from all IPS i used this blog poste https://mihaibojin.medium.com/deploy-and-configure-google-compute-engine-vms-with-terraform-f6b708b226c1
# insecure but enough for my purpose because i dont really have important files on it
resource "google_compute_network" "ipv6net" {
  provider                = google
  name                    = "ipv6net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "ipv6subnet" {
  provider         = google
  name             = "ipv6subnet"
  network          = google_compute_network.ipv6net.id
  ip_cidr_range    = "10.0.0.0/8"
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
}

resource "google_compute_firewall" "firewall" {
  provider = google
  name     = "firewall"
  network  = google_compute_network.ipv6net.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}


# Followed tutorial and made some adjustments https://cloud.google.com/docs/terraform/create-vm-instance?hl=de
# Orientation through some examples: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "tf_vm" {
  name         = "my-devops-vm"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }


  #For provisioning the artifact  https://stackoverflow.com/questions/77464753/transfer-a-file-to-a-gcp-vm-using-provisioner-and-connection-terraform
  provisioner "file" {
    source      = "artifact.bin"
    destination = "./artifact.bin"

    connection {
      type  = "ssh"
      user  = "men"
      private_key = file(var.ssh_key)
      host  = self.network_interface[0].access_config[0].nat_ip
      agent = "false"
    }
  }
}

