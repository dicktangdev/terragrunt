variable "identifier" {
  description = "Identifier for the RDS MySQL instance"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "engine_version" {
  description = "Version of the MySQL engine"
  type        = string
  default     = "8.0.31"
}

variable "mysql_major_version" {
  description = "Major version of the MySQL engine"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "Instance class for the RDS MySQL instance"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Allocated storage for the RDS MySQL instance (in GB)"
  type        = number
}

variable "max_allocated_storage" {
  description = "max_allocated_storage for the RDS MySQL instance (in GB), set 0 will disable the autoscaling"
  type        = number
}

variable "username" {
  description = "Username for the MySQL database"
  type        = string
}

variable "create_db_parameter_group" {
  description = "create_db_parameter_group"
  type        = bool
  default     = true
}

variable "create_db_option_group" {
  description = "create_db_option_group"
  type        = bool
  default     = true
}

variable "parameter_group_name" {
  description = "parameter_group_name"
  type        = string
  default     = null
}

variable "option_group_name" {
  description = "option_group_name"
  type        = string
  default     = null
}

variable "port" {
  description = "Port number for the MySQL database"
  type        = number
  default     = 3306
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the RDS MySQL instance"
  type        = list(string)
}

variable "multi_az" {
  description = "if multi_az"
  type        = bool
}
variable "tags" {
  description = "Tags to be associated with the resources"
  type        = map(string)
}
