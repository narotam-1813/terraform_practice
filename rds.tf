resource "aws_db_instance" "lambda_rds" {
  db_name              = "mydb"  
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20
  storage_type         = "gp2"
  username             = jsondecode(data.aws_secretsmanager_secret_version.database_credentials.secret_string)["DB_USERNAME"]
  password             = jsondecode(data.aws_secretsmanager_secret_version.database_credentials.secret_string)["DB_PASSWORD"]
  db_subnet_group_name = aws_db_subnet_group.lambda_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot  = true
#   final_snapshot_identifier = "whatever"
}

resource "aws_db_subnet_group" "lambda_db_subnet_group" {
  name       = "lambda-db-subnet-group"
  subnet_ids = aws_subnet.private_subnets.*.id
}
