resource "aws_lambda_function" "lambda_functions" {
  for_each = local.lambda_function_map
  function_name = each.key

  filename      = local.lambda_function_map[each.key]
  source_code_hash = filebase64sha256(local.lambda_function_map[each.key])
  runtime       = "nodejs16.x"
  handler       = "lambda.handler"
  memory_size   = 128
  role          = aws_iam_role.lambda_iam_role.arn 

  vpc_config {
    security_group_ids = [aws_security_group.lambda_sg.id]
    subnet_ids         = aws_subnet.private_subnets.*.id
  }

  environment {
    variables = {
      DB_HOST     = aws_db_instance.lambda_rds.address
      DB_USERNAME = jsondecode(data.aws_secretsmanager_secret_version.database_credentials.secret_string)["DB_USERNAME"]
      DB_PASSWORD = jsondecode(data.aws_secretsmanager_secret_version.database_credentials.secret_string)["DB_PASSWORD"]
    }
  }
}