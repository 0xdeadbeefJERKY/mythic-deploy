variable "name" {
  description = "Mythic instance name (prefix used for component nmes)"
  default     = "mythic"
  type        = string
}

variable "public_key_openssh" {
  description = "Contents of SSH public key used to connect to Mythic server"
  type        = string
}

variable "user" {
  default     = "root"
  description = "SSH username"
  type        = string
}

variable "ports" {
  description = "List of objects describing ports to be allowlisted"
  type = list(object({
    proto = string
    port  = number
    allow = list(string)
    desc  = string
  }))
  default = [
    {
      proto = "tcp"
      port  = 22
      allow = ["0.0.0.0/0", "::/0"]
      desc  = "Allow SSH access to Mythic server from allowlisted IPs"
    },
    {
      proto = "tcp"
      port  = 80
      allow = ["0.0.0.0/0", "::/0"]
      desc  = "Allow HTTP access to Mythic server from allowlisted IPs"
    },
    {
      proto = "tcp"
      port  = 443
      allow = ["0.0.0.0/0", "::/0"]
      desc  = "Allow HTTPS access to Mythic server from allowlisted IPs"
    },
    {
      proto = "tcp"
      port  = 7443
      allow = ["0.0.0.0/0", "::/0"]
      desc  = "Allow HTTPS admin access to Mythic server from allowlisted IPs"
    },
    {
      proto = "tcp"
      port  = 8080
      allow = ["0.0.0.0/0", "::/0"]
      desc  = "Allow HTTP documentation access to Mythic server from allowlisted IPs"
    },
  ]
}

variable "image" {
  description = "Droplet image to be used"
  default     = "ubuntu-18-04-x64"
  type        = string
}

variable "region" {
  description = "Digital Ocean region to which the Droplet will be deployed"
  default     = "nyc3"
  type        = string
}

variable "size" {
  description = "Droplet size of the Mythic instance"
  default     = "s-1vcpu-2gb"
  type        = string
}

variable "privkey_filename" {
  description = "Full file path to SSH private key"
  type        = string
}
