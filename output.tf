# Web Tier Load Balancer DNS
output "web-server-dns" {
  description = "DNS name of the web tier load balancer - use this to access your application"
  value       = aws_lb.alb-web.dns_name
}

# App Tier Load Balancer DNS (Internal)
output "app-server-dns" {
  description = "DNS name of the app tier load balancer (internal)"
  value       = aws_lb.alb-app.dns_name
}

# RDS Database Endpoint
output "database-endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.rds-db.endpoint
  sensitive   = true
}

# SSH Key Information
output "ssh-key-location" {
  description = "Location of the private SSH key file"
  value       = "The private key has been saved to: ${path.module}/three-tier-key.pem"
}

output "ssh-connection-example" {
  description = "Example SSH command to connect to instances"
  value       = "ssh -i three-tier-key.pem ubuntu@<instance-public-ip>"
}