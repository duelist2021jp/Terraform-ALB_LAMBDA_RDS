# Lambda Layer Definition
resource "aws_lambda_layer_version" "psycopg2_layer" {
  filename            = "~/lambda_layer/psycopg2_layer.zip" # 作成したZIPのパス
  layer_name          = "psycopg2_layer"
  compatible_runtimes = ["python3.12"]
}

# IAM Policy Definition for Secret Manager access permission
resource "aws_iam_policy" "secretsmanager_access" {
  name        = "secretsmanager_access"
  description = "Access to Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          var.secret_ARN
        ]
      }
    ]
  })
}

# Current Lambda IAM Role
data "aws_iam_role" "lambda_role"{
  name = "My_Lambda_Test_Role"
}

# Attach IAM Policy to Lambda IAM Role
resource "aws_iam_policy_attachment" "policy_attach" {
  name       = "attach_secretsmanager_access"
  roles      = [data.aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.secretsmanager_access.arn

  depends_on = [
    aws_iam_policy.secretsmanager_access
  ]

}

# Lambda Function Definition
resource "aws_lambda_function" "test" {
  filename         = "~/test/get_rds_table.zip" # Lambdaにデプロイするコードのパス
  function_name    = "get-rds-table"
  role             = data.aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  code_sha256      = filebase64sha256("~/test/get_rds_table.zip")

  layers = [
    aws_lambda_layer_version.psycopg2_layer.arn
  ]

  vpc_config{
    subnet_ids         = [var.private_subnet_id_01,var.private_subnet_id_02]
    security_group_ids = [var.lambda_sg_id]
  }

  environment{
    variables = {
      Secret_Name    = var.secret_Name
      dbname         = var.dbname
      dbhost         = var.dbhost
      port_number    = var.port_number
    }
  }

  depends_on = [
    aws_iam_policy_attachment.policy_attach,
    aws_lambda_layer_version.psycopg2_layer
  ]
}

