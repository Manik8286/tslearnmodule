output "ecs_execution_role_arn" {
  description = "ARN of the ECS execution IAM role"
  value       = aws_iam_role.ecs_execution_role.arn
}
