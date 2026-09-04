output "public_ip" {
  description = "IP Publica de la instancia EC2"
  value       = aws_instance.web.public_ip
}
