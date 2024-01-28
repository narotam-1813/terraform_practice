resource "aws_secretsmanager_secret" "database_credentials" {
  name = "lambda-db-credentials"
}