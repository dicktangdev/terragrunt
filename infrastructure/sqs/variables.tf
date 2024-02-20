variable "sqs_name" {
  type        = string
  description = "The name of sqs"
}

variable "fifo_queue" {
  type        = bool
  description = "designating a FIFO queue"
  default     = false
}

variable "message_retention_seconds" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = 345600 # 4days
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
}

variable "max_message_size" {
  type        = number
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  default     = 262144
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  default     = 20
}

variable "deduplication_scope" {
  type        = string
  description = "whether message deduplication occurs at the message group or queue level"
  default     = null # messageGroup or queue ref:https://registry.terraform.io/providers/-/aws/5.2.0/docs/resources/sqs_queue#fifo_throughput_limit
}

variable "fifo_throughput_limit" {
  type        = string
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group"
  default     = null # perQueue or perMessageGroupId ref:https://registry.terraform.io/providers/-/aws/5.2.0/docs/resources/sqs_queue#fifo_throughput_limit
}

variable "content_based_deduplication" {
  type        = bool
  description = "Enables content-based deduplication for FIFO queues"
  default     = null
}

variable "create_dlq" {
  type        = bool
  description = "Determines whether to create SQS dead letter queue"
}

variable "dlq_name" {
  type        = string
  description = "dlq name"
  default     = null
}

variable "dlq_delay_seconds" {
  type        = number
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  default     = null
}

variable "dlq_message_retention_seconds" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = null
}

variable "dlq_visibility_timeout_seconds" {
  type        = number
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  default     = null
}

variable "dlq_receive_wait_time_seconds" {
  type        = number
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  default     = null
}

variable "redrive_allow_policy" {
  description = "Redrive allow policy configuration"
  type        = map(any)
  default     = {}
}

variable "redrive_policy" {
  description = "Redrive policy configuration"
  type        = map(any)
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VPC resources"
  default = {
    Terragrunt  = "true"
    Environment = "dev"
  }
}