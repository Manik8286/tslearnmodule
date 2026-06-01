variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "public_subnet_1_id" {
  description = "First public subnet ID"
  type        = string
}

variable "public_subnet_2_id" {
  description = "Second public subnet ID"
  type        = string
}
