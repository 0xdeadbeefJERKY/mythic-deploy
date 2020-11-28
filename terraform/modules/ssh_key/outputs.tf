output "public_key_openssh" {
  description = "SSH public key contents"
  value       = tls_private_key.main.public_key_openssh
}

output "privkey_filename" {
  description = "SSH private key filename"
  value       = local_file.privkey.filename
}
