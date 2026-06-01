output "cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.ts_cluster.id
}

output "service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.task_service.name
}
