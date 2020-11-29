provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

# Enable Cloud Resource Manager API for project
resource "google_project_service" "main" {
  project = var.project
  service = "cloudresourcemanager.googleapis.com"
}

# Create network within project to which the Mythic VM will be deployed
resource "google_compute_network" "main" {
  name                    = "${var.name}-network"
  auto_create_subnetworks = "false"
  project                 = var.project
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "main" {
  name          = "${var.name}-subnetwork"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id
}

# Create firewall that restricts inbound traffic for Mythic server
resource "google_compute_firewall" "main" {
  for_each = { for port in var.ports : port.port => port }
  name     = "allow-${each.value.port}"
  network  = google_compute_network.main.self_link
  project  = google_compute_network.main.project

  allow {
    protocol = each.value.proto
    ports    = [each.value.port]
  }

  source_ranges = each.value.allow
}

# Create Mythic VM instance
resource "google_compute_instance" "main" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.main.id

    access_config {
      # Creates an ephemeral IP for the VM instance
    }
  }

  metadata = {
    ssh-keys = "${var.user}:${var.public_key_openssh}"
  }

  depends_on = [google_project_service.main]
}

# Create SSH config file
resource "local_file" "sshconfig" {
  content = templatefile("${path.cwd}/templates/config.tpl", {
    host         = var.name
    hostname     = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
    identityfile = var.privkey_filename
    user         = var.user
  })
  filename = "${path.cwd}/ssh_keys/config"
}

# Populate Ansible inventory file
resource "local_file" "inventory" {
  content = templatefile("${path.cwd}/templates/inventory.tpl", {
    host         = var.name
    hostname     = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
    identityfile = var.privkey_filename
    user         = var.user
  })
  filename = "${path.cwd}/../ansible/inventory"
}
