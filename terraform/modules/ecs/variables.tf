variable "app_image" {
  description = "Docker image URL from ECR"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS execution IAM role"
  type        = string
}

variable "app_subnet_id" {
  description = "Private subnet ID for ECS tasks"
  type        = string
}

variable "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "listener_arn" {
  description = "ARN of the ALB listener (used for depends_on)"
  type        = string
}

variable "db_host" {
  description = "RDS hostname"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
