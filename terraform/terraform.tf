terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
  required_version = ">= 1.2"
  backend "s3" {
    bucket = "tsstate-mani-2026"
    key    = "task-manager/terraform.tfstate"
    region = "us-east-1"
  }
}