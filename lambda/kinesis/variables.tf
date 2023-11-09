variable "kinesis_stream_arn" {
  description = "The stream arn to be processed"
}

variable "batch_size" {
  default = 200
}

variable "function_name" {
  description = "The name of the function"
}

variable "path" {
  description = "The function's folder (the folder will be sent as the code for the lambda)"
  default     = null
}

variable "s3_bucket" {
  description = "The function's s3 bucket"
  default     = null
}

variable "s3_key" {
  description = "The function's s3 key"
  default     = null
}

variable "handler" {
  description = "The handler of the function (file.method)"
}

variable "variables" {
  type = map(any)

  default = {
    EMPTY_ENVIRONMENT = true
  }
}

variable "timeout" {
  default = 3
}

variable "vpc_config_enabled" {
  default = false
}

variable "vpc_config" {
  default = {}
}

variable "extra_policy_statements" {
  type    = list(any)
  default = []
}

variable "runtime" {
  default = "nodejs8.10"
}

variable "memory_size" {
  default = 128
}

variable "reserved_concurrent_executions" {
  default = -1
}

variable "layers" {
  type    = list(any)
  default = []
}

variable "source_code_hash" {
  default = null
}

variable "tags" {
  default = {}
  type    = map(string)
}

variable "parallelization_factor" {
  default = 4
}
