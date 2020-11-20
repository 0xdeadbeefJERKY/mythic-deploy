provider "digitalocean" {}

# Generate SSH keypair
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Save private key to local file
resource "local_file" "privkey" {
  content = tls_private_key.default.private_key_pem
  filename = "${path.cwd}/ssh_keys/${var.name}"
  file_permission = "0600"
}

# Save public key to local file
resource "local_file" "pubkey" {
  content = tls_private_key.default.public_key_openssh
  filename = "${path.cwd}/ssh_keys/${var.name}.pub"
}

# Add SSH key to Digital Ocean
resource "digitalocean_ssh_key" "default" {
  name       = "${var.name}-ssh-key"
  public_key = tls_private_key.default.public_key_openssh
}

# Create Digital Ocean firewall that restricts inbound 
# traffic for Mythic server
resource "digitalocean_firewall" "default" {
  name = "ssh-and-mythic-ports-only"

  droplet_ids = [digitalocean_droplet.mythic.id]

  dynamic "inbound_rule" {
    for_each = [for p in var.ports: {
      proto = p.proto
      port = p.port
      allow = p.allow
    }]

    content {
      protocol = inbound_rule.value.proto
      port_range = inbound_rule.value.port
      source_addresses = inbound_rule.value.allow
    }
  }
  
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Create Droplet to which Mythic will be deployed
resource "digitalocean_droplet" "mythic" {
  image  = var.image
  name   = var.name
  region = var.region
  size   = var.size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

# Create SSH config file
resource "local_file" "sshconfig" {
  content = templatefile("${path.cwd}/templates/config.tpl", {
    host = var.name
    hostname = digitalocean_droplet.mythic.ipv4_address
    identityfile = local_file.privkey.filename
    user = "root"
  })
  filename = "${path.cwd}/ssh_keys/config"
}

# Populate Ansible inventory file
resource "local_file" "inventory" {
  content = templatefile("${path.cwd}/templates/inventory.tpl", {
    host = var.name
    hostname = digitalocean_droplet.mythic.ipv4_address
    identityfile = local_file.privkey.filename
    user = "root"
  })
  filename = "${path.cwd}/../ansible/inventory"
}
