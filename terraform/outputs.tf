output "droplet_ip" {
  value = digitalocean_droplet.mythic.ipv4_address
  description = "Mythic server IPv4 address"
}