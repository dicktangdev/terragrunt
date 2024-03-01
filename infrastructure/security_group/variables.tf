variable "name" {
  type        = string
  description = "The name of the sg"
  default     = "dev-sg"
}

variable "description" {
  description = "The description of sg"
  default     = "development sg"
}

variable "vpc_id" {
  type        = string
  description = "ID of target VPC"
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the instance"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}