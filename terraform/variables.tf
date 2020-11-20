variable "image" {
  default = "ubuntu-20-04-x64"
  description = "Droplet image to be used for Mythic server"
} 

variable "name" {
  default = "mythic-server"
  description = "Name of Mythic server instance - this will be used for other naming schemes as well (e.g., SSH keypair names)"
} 

variable "region" {
  default = "nyc3"
  description = "Digital Ocean region to which the Droplet will be deployed"
} 

variable "size" {
  default = "s-2vcpu-4gb"
  description = "Droplet size"
} 

variable "ports" {
  default = [
    {
      proto   = "tcp"
      port = 22
      allow = ["24.44.142.177/32", "::/0"]
    },
    {
      proto   = "tcp"
      port = 80
      allow = ["24.44.142.177/32", "::/0"]
    },
    {
      proto   = "tcp"
      port = 443
      allow = ["24.44.142.177/32", "::/0"]
    },
    {
      proto   = "tcp"
      port = 7443
      allow = ["24.44.142.177/32", "::/0"]
    },
    {
      proto   = "tcp"
      port = 8080
      allow = ["24.44.142.177/32", "::/0"]
    },
  ]
  description = "Ports and allowed IPs for ingress traffic to Mythic server"
}