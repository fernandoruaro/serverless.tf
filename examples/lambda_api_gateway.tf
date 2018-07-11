module "lambda_api_gateway_simple" {
  source = "../lambda/api_gateway"

  function_name = "lambda-api-gateway-simple"
  handler       = "index.handler"
  path          = "./code"
}
