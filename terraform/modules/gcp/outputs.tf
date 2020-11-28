output "vm_ip" {
  value = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
  description = "Public IP for Mythic VM instance"
}

output "hostname" {
  value = var.name
  description = "Hostname assigned to server for SSH connections"
}

output "ssh_config" {
  value = local_file.sshconfig.filename
  description = "Full path to SSH config file"
}