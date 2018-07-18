resource "aws_dynamodb_table" "test_stream" {
  name             = "test-dynamo-stream"
  hash_key         = "ID"
  read_capacity    = 1
  write_capacity   = 1
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "ID"
    type = "S"
  }
}

module "lambda_dynamodb_simple" {
  source = "../lambda/dynamodb"

  dynamodb_stream_arn = "${aws_dynamodb_table.test_stream.stream_arn}"
  function_name       = "lambda-dynamodb-simple"
  handler             = "index.handler"
  path                = "./code"
}
