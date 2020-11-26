variable "ports" {}

module "ssh_key" {
  source = "./modules/ssh_key"
}

module "aws" {
  source = "./modules/aws"
  public_key_openssh = module.ssh_key.public_key_openssh
  ports = var.ports
  privkey_filename = module.ssh_key.privkey_filename
}

output "ec2_ip" {
  value = module.aws.ec2_ip
}

output "ssh_connect_cmd" {
  value = "ssh -F ${module.aws.ssh_config} ${module.aws.hostname}"
}