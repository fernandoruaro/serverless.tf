module "lambda_default_simple" {
  source = "../lambda/default"

  function_name = "lambda-default-simple"
  handler       = "index.handler"
  path          = "./code"
}

module "lambda_default_policy" {
  source = "../lambda/default"

  function_name = "lambda-default-policy"
  handler       = "index.handler"
  path          = "./code"

  extra_policy_statements = [
    <<EOF
{
      "Effect": "Allow",
      "Action": ["dynamodb:*"],
      "Resource": "arn:aws:dynamodb:*"
}
EOF
    ,
  ]
}
