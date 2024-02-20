variable "name" {
  type        = string
  description = "The name of the VPC"
  default     = "tg-vpc"
}

variable "cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.174.32.0/22"
}

variable "secondary_cidr_blocks" {
  type        = list(string)
  description = "The secondary_cidr_blocks for the VPC"
  default     = []
}

variable "azs" {
  type        = list(string)
  description = "The availability zones for the VPC"
  default     = ["ap-east-1a", "ap-east-1b", "ap-east-1c"]
}

variable "private_subnets" {
  type        = list(string)
  description = "The private subnets for the VPC"
  default     = ["10.174.33.128/25", "10.174.34.0/25", "10.174.34.128/25"]
}

variable "public_subnets" {
  type        = list(string)
  description = "The public subnets for the VPC"
  default     = ["10.174.32.0/25", "10.174.32.128/25", "10.174.33.0/25"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to create a NAT gateway for the VPC"
  default     = true
}
variable "single_nat_gateway" {
  type        = bool
  description = "Whether to create only one NAT gateway"
  default     = true
}

variable "private_subnet_tags" {
  description = "A map of tags to assign to the private subnet"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "A map of tags to assign to the public subnet"
  type        = map(string)
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