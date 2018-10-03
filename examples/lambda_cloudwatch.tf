module "lambda_cloudwatch_simple" {
  source = "../lambda/cloudwatch"

  function_name       = "lambda-cloudwatch-simple"
  handler             = "index.handler"
  path                = "./code"
  schedule_expression = "rate(1 minute)"
}
