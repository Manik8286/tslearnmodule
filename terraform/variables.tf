variable "app_image" {
  description = "Docker image URL from ECR"
  type        = string
  default     = "897722694412.dkr.ecr.us-east-1.amazonaws.com/tsk-image:latest"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
