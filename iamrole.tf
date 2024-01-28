resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_cloudwatch_log_group" "lambda_log_groups" {
  for_each = local.lambda_function_map

  name = "/aws/lambda/${each.key}"
  retention_in_days = 30
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = ["arn:aws:logs:${var.region}:${var.aws_account}:log-group:*"]
    },
    {
      Effect = "Allow"
      Action = [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ]
      Resource = ["*"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role = aws_iam_role.lambda_iam_role.name
}