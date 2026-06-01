provider "aws" {
  region = "us-east-1"
}

# -------------------------------------------------------
# Networking — VPC, subnets, IGW, NAT, route tables
# -------------------------------------------------------
module "networking" {
  source = "git@github-personal:Manik8286/tslearnmodule.git//terraform/modules/networking?ref=main"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_1_cidr = "10.0.1.0/24"
  public_subnet_2_cidr = "10.0.4.0/24"
  app_subnet_cidr      = "10.0.2.0/24"
  rds_subnet_cidr      = "10.0.3.0/24"
}

# -------------------------------------------------------
# Security Groups — depends on networking
# -------------------------------------------------------
module "security_group" {
  source = "git@github-personal:Manik8286/tslearnmodule.git//terraform/modules/security_group?ref=main"

  vpc_id = module.networking.vpc_id
}

# -------------------------------------------------------
# ALB — depends on networking + security_group
# -------------------------------------------------------
module "alb" {
  source = "git@github-personal:Manik8286/tslearnmodule.git//terraform/modules/alb?ref=main"

  vpc_id             = module.networking.vpc_id
  alb_sg_id          = module.security_group.alb_sg_id
  public_subnet_1_id = module.networking.public_subnet_1_id
  public_subnet_2_id = module.networking.public_subnet_2_id
}

# -------------------------------------------------------
# ECR — independent
# -------------------------------------------------------
module "ecr" {
  source   = "git@github-personal:Manik8286/tslearnmodule.git//terraform/modules/ecr?ref=main"
  ecr_name = "tsk-image"
}

# -------------------------------------------------------
# IAM — independent
# -------------------------------------------------------
module "iam" {
  source = "git@github-personal:Manik8286/tslearnmodule.git//terraform/modules/iam?ref=main"
}

# -------------------------------------------------------
# ECS — depends on networking, security_group, alb, iam
# -------------------------------------------------------
module "ecs" {
  source = "git@github-personal:Manik8286/tslearnmodule.git//terraform/modules/ecs?ref=main"

  app_image          = var.app_image
  execution_role_arn = module.iam.ecs_execution_role_arn
  app_subnet_id      = module.networking.app_subnet_id
  ecs_sg_id          = module.security_group.ecs_sg_id
  target_group_arn   = module.alb.target_group_arn
  listener_arn       = module.alb.listener_arn

  db_host     = module.database.db_host
  db_name     = module.database.db_name
  db_username = "taskadmin"
  db_password = var.db_password
}

# -------------------------------------------------------
# S3 — independent
# -------------------------------------------------------
module "s3" {
  source      = "git@github-personal:Manik8286/tslearnmodule.git//terraform/modules/s3?ref=main"
  bucket_name = "learning-taskbucket-mani-2026"
}

module "database" {
  source = "git@github-personal:Manik8286/tslearnmodule.git//terraform/modules/database?ref=main"

  vpc_id      = module.networking.vpc_id
  rds_sg_id   = module.security_group.rds_sg_id
  db_name     = "taskdb"
  db_username = "taskadmin"
  db_password = var.db_password
}