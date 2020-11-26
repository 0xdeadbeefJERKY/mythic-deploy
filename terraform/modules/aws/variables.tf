variable "name" {
  description = "Mythic instance name (prefix used for component nmes)"
  default = "mythic"
  type = string
}

variable "ami" {
  description = "EC2 AMI to be used"
  default = "ami-0b893eef6e21b60a1" # Ubuntu 18.04 (Bionic) in us-east-1 region
}

variable "instance_type" {
  default = "t2.small"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "CIDR block assigned to VPC"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
  description = "CIDR block assigned to subnet in VPC"
}

variable "public_key_openssh" {
  description = "Contents of SSH public key used to connect to Mythic server"
  type = string
}

variable "ports" {
  description = "List of objects describing ports to be allowlisted"
  type = list(object({
    proto = string
    port = number
    allow = list(string)
    desc = string
  }))
  default =  [
    {
      proto   = "tcp"
      port = 22
      allow = ["0.0.0.0/0", "::/0"]
      desc = "Allow SSH access to Mythic server from allowlisted IPs"
    },
    {
      proto   = "tcp"
      port = 80
      allow = ["0.0.0.0/0", "::/0"]
      desc = "Allow HTTP access to Mythic server from allowlisted IPs"
    },
    {
      proto   = "tcp"
      port = 443
      allow = ["0.0.0.0/0", "::/0"]
      desc = "Allow HTTPS access to Mythic server from allowlisted IPs"
    },
    {
      proto   = "tcp"
      port = 7443
      allow = ["0.0.0.0/0", "::/0"]
      desc = "Allow HTTPS admin access to Mythic server from allowlisted IPs"
    },
    {
      proto   = "tcp"
      port = 8080
      allow = ["0.0.0.0/0", "::/0"]
      desc = "Allow HTTP documentation access to Mythic server from allowlisted IPs"
    },
  ]
  
}

variable "privkey_filename" {
  description = "Full file path to SSH private key"
}