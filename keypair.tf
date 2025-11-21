# Generate SSH key pair for EC2 instances
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair using the generated public key
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "three-tier-key"
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = {
    Name = "three-tier-ec2-key"
  }
}

# Save private key locally (for SSH access to instances)
resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/three-tier-key.pem"
  file_permission = "0400"
}
