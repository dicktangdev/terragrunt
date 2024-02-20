data "aws_caller_identity" "current" {}
module "sqs" {
  source = "terraform-aws-modules/sqs/aws"

  name                        = var.sqs_name
  fifo_queue                  = var.fifo_queue
  message_retention_seconds   = var.message_retention_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  max_message_size            = var.max_message_size
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  deduplication_scope         = var.deduplication_scope
  fifo_throughput_limit       = var.fifo_throughput_limit
  content_based_deduplication = var.content_based_deduplication

  create_dlq                     = var.create_dlq
  dlq_name                       = var.dlq_name
  dlq_delay_seconds              = var.dlq_delay_seconds
  dlq_message_retention_seconds  = var.dlq_message_retention_seconds
  dlq_visibility_timeout_seconds = var.dlq_visibility_timeout_seconds
  dlq_receive_wait_time_seconds  = var.dlq_receive_wait_time_seconds
  create_queue_policy  = true
  queue_policy_statements = {
    account = {
      sid = "AccountReadWrite"
      actions = [
        "SQS:*"
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        }
      ]
    }
  }
  tags           = var.tags
}

resource "aws_sqs_queue_redrive_allow_policy" "sqs" {
  queue_url = module.sqs.queue_id

  redrive_allow_policy = jsonencode({
    redrivePermission = "allowAll",
  })
}