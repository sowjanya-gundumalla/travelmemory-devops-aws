output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "web_server_public_dns" {
  description = "Public DNS of the web server"
  value       = aws_instance.web.public_dns
}

output "db_server_private_ip" {
  description = "Private IP of the database server"
  value       = aws_instance.db.private_ip
}
