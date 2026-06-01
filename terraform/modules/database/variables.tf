variable "rds_sg_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "taskdb"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "taskadmin"
}

variable "db_password" {
  description = "Master password for RDS — use a secret manager in production"
  type        = string
  sensitive   = true   # hides value from terraform output and logs
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
