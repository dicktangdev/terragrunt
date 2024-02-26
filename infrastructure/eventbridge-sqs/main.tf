resource "aws_scheduler_schedule" "scheduler" {
  name        = var.scheduler_name
  description = var.description
  flexible_time_window {
    mode = "OFF"
  }
  state                        = var.state
  group_name                   = var.group_name
  schedule_expression_timezone = "Asia/Hong_Kong"
  schedule_expression          = var.schedule_expression


  target {
    arn      = "arn:aws:scheduler:::aws-sdk:sqs:sendMessage"
    role_arn = "arn:aws:iam::101285038298:role/service-role/Amazon_EventBridge_Scheduler_SQS_CMS_JOB"
    dead_letter_config {
      arn = var.dlq_arn
    }
    retry_policy {
      maximum_retry_attempts       = 0
      maximum_event_age_in_seconds = 60
    }
    input = jsonencode({
      MessageBody            = var.MessageBody
      QueueUrl               = var.sqs_queue_url
      MessageGroupId         = var.MessageGroupId
      MessageDeduplicationId = var.MessageDeduplicationId
      MessageAttributes      = var.MessageAttributes
    })
  }
}