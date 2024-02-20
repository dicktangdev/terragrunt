variable "subfolder_keys" {
  type    = list(string)
  default = []
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
}

variable "acl" {
  description = "The ACL (access control list) for the S3 bucket"
}

variable "tags" {
  description = "A map of tags to assign to the instance"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}