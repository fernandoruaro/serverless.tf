output "lambda_arn" {
  value = aws_lambda_function.default.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.default.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.default.function_name
}
