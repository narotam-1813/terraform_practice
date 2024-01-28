variable region{
    default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "num_public_subnets" {
  default = 2
}

variable "num_private_subnets" {
  default = 2
}
variable "aws_account" {
  default = "1234567890"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_secretsmanager_secret_version" "database_credentials" {
  secret_id = "lambda-db-credentials"
}

locals {
  lambda_function_map = {
    "lambda_function1" = "lambda_function1.zip"
    "lambda_function2" = "lambda_function2.zip"
    "lambda_function3" = "lambda_function3.zip"
    "lambda_function4" = "lambda_function4.zip"
    "lambda_function5" = "lambda_function5.zip"
    "lambda_function6" = "lambda_function6.zip"
    "lambda_function7" = "lambda_function7.zip"
    "lambda_function8" = "lambda_function8.zip"
  }
}