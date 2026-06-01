variable "app_image" {
  description = "Docker image URL from ECR"
  type        = string
  default     = "public.ecr.aws/docker/library/python:3.12-slim"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
