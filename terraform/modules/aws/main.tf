provider "aws" {}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr 

  tags = {
    Name = "${var.name}-vpc"
  }
}

# Create a subnet in the VPC
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "${var.name}-subnet"
  }
}

# Add SSH key to AWS
resource "aws_key_pair" "main" {
  key_name   = "${var.name}-keypair"
  public_key = var.public_key_openssh
}

# Create Security Group that restricts inbound 
# traffic for Mythic server
resource "aws_security_group" "main" {
  name        = "ssh-and-mythic-ports-only"
  description = "Allow access to Mythic server"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = [for p in var.ports: {
      proto = p.proto
      port = p.port
      allow = p.allow
      desc = p.desc
    }]

    content {
      description = ingress.value.desc
      protocol = ingress.value.proto
      from_port = ingress.value.port
      to_port = ingress.value.port
      cidr_blocks = ingress.value.allow
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

# Create EC2 instance to which Mythic will be deployed
resource "aws_instance" "mythic" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.main.key_name
  security_groups = [aws_security_group.main.id]
  subnet_id = aws_subnet.main.id
  associate_public_ip_address = true

  tags = {
    Name = "${var.name}-ec2"
  }
}

# Deploy internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-ig"
  }
}

# Setup route table and associate with subnet
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.name}-rt"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create SSH config file
resource "local_file" "sshconfig" {
  content = templatefile("${path.cwd}/templates/config.tpl", {
    host = var.name
    hostname = aws_instance.mythic.public_ip
    identityfile = var.privkey_filename
    user = "ubuntu"
  })
  filename = "${path.cwd}/ssh_keys/config"
}

# Populate Ansible inventory file
resource "local_file" "inventory" {
  content = templatefile("${path.cwd}/templates/inventory.tpl", {
    host = var.name
    hostname = aws_instance.mythic.public_ip
    identityfile = var.privkey_filename
    user = "ubuntu"
  })
  filename = "${path.cwd}/../ansible/inventory"
}
