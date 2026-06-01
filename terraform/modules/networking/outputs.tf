output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_1_id" {
  description = "ID of first public subnet"
  value       = aws_subnet.main.id
}

output "public_subnet_2_id" {
  description = "ID of second public subnet"
  value       = aws_subnet.main2.id
}

output "app_subnet_id" {
  description = "ID of the private app subnet"
  value       = aws_subnet.app_subnet.id
}

output "rds_subnet_id" {
  description = "ID of the private RDS subnet"
  value       = aws_subnet.rds_subnet.id
}
