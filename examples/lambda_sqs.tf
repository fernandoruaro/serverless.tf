resource "aws_sqs_queue" "queue" {
  name = "sqs-to-lambda-test"
}

module "lambda_sqs_simple" {
  source = "../lambda/sqs"

  function_name = "lambda-sqs-simple"
  handler       = "index.handler"
  path          = "./code"

  sqs_arn = "${aws_sqs_queue.queue.arn}"
}
