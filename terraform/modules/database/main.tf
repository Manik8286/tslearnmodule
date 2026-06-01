# -------------------------------------------------------
# RDS Subnet Group
# RDS requires at least 2 subnets in different AZs
# -------------------------------------------------------
resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.rds_subnet1.id, aws_subnet.rds_subnet2.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_subnet" "rds_subnet1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1a"
  tags = { Name = "RDS Main" }
}

resource "aws_subnet" "rds_subnet2" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1b"
  tags = { Name = "RDS Main2" }
}

# -------------------------------------------------------
# RDS Instance (PostgreSQL)
# -------------------------------------------------------
resource "aws_db_instance" "postgres" {
  identifier        = "task-manager-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"   # cheapest — fine for learning
  allocated_storage = 20              # GB

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [var.rds_sg_id]

  # Learning/dev settings
  skip_final_snapshot     = true   
  deletion_protection     = false 
  publicly_accessible     = false 
  multi_az                = false  

  tags = {
    Name        = "task-manager-db"
    Environment = "dev"
  }
}
