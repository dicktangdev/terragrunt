variable "name" {
  type        = string
  description = "The name of the instance"
  default     = "tg-ec2"
}

variable "ami_id" {
  type        = string
  description = "The ami id"
  default     = "ami-03d48f1559675ccc0"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  default     = "user1"
}

variable "security_group_id" {
  description = "Security group ID to associate with the instance"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string
}

variable "user_data" {
  description = "user data"
  type        = string
  default     = ""
}

variable "azs" {
  description = "azs"
  type        = list(string)
}

variable "aws_ebs_volume_size" {
  description = "ebs_volume_size"
  type        = number
}


variable "tags" {
  description = "A map of tags to assign to the instance"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}