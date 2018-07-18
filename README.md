# serverless.tf

This repository has some modules for configuring api gateways and creating lambdas on AWS using Terraform.

The examples folder has the usage of each module.

### Current modules:

- `/api_gateway/resource`

Api Gateway Resource wrapper with CORS enabled

- `/api_gateway/method/lambda`

Api Gateway Method that has Lambda Integration

- `/lambda/default`

AWS Lambda with Dead Letter Queue, Role and Policy configuration.

- `/lambda/api_gateway`

AWS Lambda adjusted to run on top of a Api Gateway

- `/lambda/kinesis`

AWS Lambda configured to run on top of a Kinesis stream

