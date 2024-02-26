variable "scheduler_name" {
  type        = string
  description = "The name of the AWS Scheduler schedule."
}

variable "description" {
  type        = string
  description = "The description of the AWS Scheduler schedule."
}

variable "schedule_expression" {
  type        = string
  description = "The schedule expression for the AWS Scheduler schedule."
}

variable "state" {
  type        = string
  description = "The state of the AWS Scheduler schedule."
}

variable "group_name" {
  type        = string
  description = "The group name of the AWS Scheduler schedule."
}

variable "dlq_arn" {
  type        = string
  description = "The ARN of the dead-letter queue for the AWS Scheduler schedule."
}

variable "MessageBody" {
  type        = string
  description = "The message body for the AWS Scheduler schedule."
}

variable "sqs_queue_url" {
  type        = string
  description = "The SQS queue URL for the AWS Scheduler schedule."
}

variable "MessageGroupId" {
  type        = string
  description = "The message group ID for the AWS Scheduler schedule."
}

variable "MessageDeduplicationId" {
  type        = string
  description = "The message deduplication ID for the AWS Scheduler schedule."
}

variable "MessageAttributes" {
  type = map(object({
    DataType    = string
    StringValue = string
  }))
}