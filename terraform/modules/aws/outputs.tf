output "ec2_ip" {
  value = aws_instance.mythic.public_ip
  description = "Public IP for Mythic EC2 instance"
}

output "hostname" {
  value = var.name
  description = "Hostname assigned to server for SSH connections"
}

output "ssh_config" {
  value = local_file.sshconfig.filename
  description = "Full path to SSH config file"
}