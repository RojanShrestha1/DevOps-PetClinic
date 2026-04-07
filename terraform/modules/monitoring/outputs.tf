output "monitoring_public_ip" {
  value       = aws_instance.monitoring_server.public_ip
  description = "The public IP address of the Monitoring/Grafana server"
}