variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR for first public subnet (us-east-1a)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR for second public subnet (us-east-1b)"
  type        = string
  default     = "10.0.4.0/24"
}

variable "app_subnet_cidr" {
  description = "CIDR for private app subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "rds_subnet_cidr" {
  description = "CIDR for private RDS subnet"
  type        = string
  default     = "10.0.3.0/24"
}
