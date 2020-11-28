output "droplet_ip" {
  value       = digitalocean_droplet.mythic.ipv4_address
  description = "Mythic server IPv4 address"
}

output "hostname" {
  value       = var.name
  description = "Hostname assigned to server for SSH connections"
}

output "ssh_config" {
  value       = local_file.sshconfig.filename
  description = "Full path to SSH config file"
}
