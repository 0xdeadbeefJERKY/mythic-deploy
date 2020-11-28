variable "ports" {}

module "ssh_key" {
  source = "./modules/ssh_key"
}

module "gcp" {
  source = "./modules/gcp"
  public_key_openssh = module.ssh_key.public_key_openssh
  ports = var.ports
  privkey_filename = module.ssh_key.privkey_filename
  project = "mythic-deploy-test"
  region = "us-east1"
  zone = "us-east1-b"
}

output "vm_ip" {
  value = module.gcp.vm_ip
}

output "ssh_connect_cmd" {
  value = "ssh -F ${module.gcp.ssh_config} ${module.gcp.hostname}"
}