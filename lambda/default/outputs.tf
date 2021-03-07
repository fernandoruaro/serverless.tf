output "lambda_arn" {
  value = aws_lambda_function.lambda.arn ? aws_lambda_function.lambda.arn : null
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn ? aws_lambda_function.lambda.invoke_arn : null
}

output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name ? aws_lambda_function.lambda.function_name : null
}
