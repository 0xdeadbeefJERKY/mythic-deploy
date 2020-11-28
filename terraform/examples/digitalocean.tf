variable "ports" {}

module "ssh_key" {
  source = "./modules/ssh_key"
}

module "digitalocean" {
  source             = "./modules/digitalocean"
  public_key_openssh = module.ssh_key.public_key_openssh
  ports              = var.ports
  privkey_filename   = module.ssh_key.privkey_filename
}

output "droplet_ip" {
  value = module.digitalocean.droplet_ip
}

output "ssh_connect_cmd" {
  value = "ssh -F ${module.digitalocean.ssh_config} ${module.digitalocean.hostname}"
}
