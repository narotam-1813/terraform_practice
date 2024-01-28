resource "aws_vpc" "lambda_vpc" {
  cidr_block = var.vpc_cidr
}


resource "aws_subnet" "public_subnets" {
  count = var.num_public_subnets

  vpc_id            = aws_vpc.lambda_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

resource "aws_subnet" "private_subnets" {
  count = var.num_private_subnets

  vpc_id            = aws_vpc.lambda_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

resource "aws_security_group" "lambda_sg" {
  vpc_id = aws_vpc.lambda_vpc.id

  # Allowing inbound traffic to Lambda functions
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.lambda_vpc.id

  # Allowing inbound traffic from Lambda functions
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
  }
}