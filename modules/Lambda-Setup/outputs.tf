output "lambda_arn"{
  value = aws_lambda_function.test.arn
}

output "lambda_function_name"{
  value = aws_lambda_function.test.function_name
}