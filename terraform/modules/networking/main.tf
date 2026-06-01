resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "main" }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { Name = "Main" }
}

resource "aws_subnet" "main2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = { Name = "Main2" }
}

resource "aws_subnet" "app_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.app_subnet_cidr
  tags       = { Name = "App" }
}

resource "aws_subnet" "rds_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.rds_subnet_cidr
  tags       = { Name = "RDS" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "nat-eip" }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.main.id
  tags          = { Name = "gw NAT" }
  depends_on    = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = { Name = "public-route-table" }
}

resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = { Name = "Private-App-route" }
}

resource "aws_route_table" "rds_rt" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "RDS-route" }
}

resource "aws_route_table_association" "public_ass" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_ass2" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "app_ass" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_rt.id
}

resource "aws_route_table_association" "rds_ass" {
  subnet_id      = aws_subnet.rds_subnet.id
  route_table_id = aws_route_table.rds_rt.id
}
