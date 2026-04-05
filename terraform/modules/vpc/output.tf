output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_1a_id" {
  description = "The ID of the public subnet in 1a"
  value       = aws_subnet.public_1a.id
}

output "public_subnet_1b_id" {
  description = "The ID of the public subnet in 1b"
  value       = aws_subnet.public_1b.id
}

output "public_subnet_ids" {
  description = "List of both public subnet IDs"
  value       = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
}