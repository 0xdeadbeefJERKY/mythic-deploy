# Generate SSH keypair
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Save private key to local file
resource "local_file" "privkey" {
  content = tls_private_key.main.private_key_pem
  filename = "${path.cwd}/ssh_keys/${var.name}"
  file_permission = "0600"
}

# Save public key to local file
resource "local_file" "pubkey" {
  content = tls_private_key.main.public_key_openssh
  filename = "${path.cwd}/ssh_keys/${var.name}.pub"
}