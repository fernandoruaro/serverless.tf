resource "aws_kinesis_stream" "test_stream" {
  name        = "test-stream"
  shard_count = 1
}

module "lambda_kinesis_simple" {
  source = "../lambda/kinesis"

  kinesis_stream_arn = "${aws_kinesis_stream.test_stream.arn}"
  function_name      = "lambda-kinesis-simple"
  handler            = "index.handler"
  path               = "./code"
}
