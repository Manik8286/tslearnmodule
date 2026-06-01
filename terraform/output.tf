output "alb_dns_name" {
  description = "ALB DNS — use this as your API base URL"
  value       = module.alb.alb_dns_name
}

output "frontend_url" {
  description = "S3 static website URL"
  value       = module.s3.website_url
}

output "ecr_repository_url" {
  description = "ECR repository URL for pushing Docker images"
  value       = module.ecr.repository_url
}
