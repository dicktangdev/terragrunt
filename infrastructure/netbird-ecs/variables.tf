variable "name" {
  default     = "Netbird"
  description = "Used to name resources and tags"
}

variable "wt_log_level" {
  default     = "debug"
  description = "As example, this is set to debug mode by default"
}

variable "wt_setup_key" {
  default     = "99915FC6-AADA-4E76-838D-10D626E13BD9"
  description = "Wiretrustee setup key"
  sensitive   = true
}

variable "docker_image" {
  default     = "wiretrustee/wiretrustee:latest"
  description = "Wiretrustee's client docker image. Must support environment variables"
}

variable "instance_type" {
  default     = "t3.small"
  description = "Autoscaling group instance type"
}

variable "vpc_default_security_group_id" {
  description = "vpc default_security_group_id"
}

variable "vpc_private_subnets" {
  type        = set(string)
  description = "vpc private_subnets"
}

variable "key_name" {
  default     = "netbird-kp"
  description = "key pair name"
}