module "mysql" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.identifier

  engine                = "mysql"
  engine_version        = "8.0" # DB parameter group
  major_engine_version  = "8.0" # DB option group
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  multi_az              = var.multi_az
  skip_final_snapshot   = true
  deletion_protection   = false

  # DB parameter group
  family                    = "mysql8.0"
  create_db_parameter_group = false
  parameter_group_name      = aws_db_parameter_group.mysql.name

  # DB option group
  create_db_option_group = false
  option_group_name      = aws_db_option_group.mysql.name

  username     = var.username
  port         = var.port
  storage_type = "gp3"

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  enabled_cloudwatch_logs_exports = data.aws_rds_engine_version.mysql.exportable_log_types

  create_monitoring_role          = true
  monitoring_role_use_name_prefix = true
  monitoring_interval             = 60
  # performance_insights_enabled          = true   
  # performance_insights_retention_period = 7

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  tags = var.tags

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.public_subnet_ids
  publicly_accessible    = true

}

resource "aws_security_group" "rds_security_group" {
  name_prefix = "rds-security-group"
  description = "Security group for RDS MySQL instance"
  vpc_id      = var.vpc_id
  ingress {
    description = "MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_rds_engine_version" "mysql" {
  engine = "mysql"

  version = var.engine_version
}

resource "aws_db_parameter_group" "mysql" {
  name   = var.parameter_group_name
  family = data.aws_rds_engine_version.mysql.parameter_group_family

  parameter {
    name  = "max_user_connections"
    value = "2000"
  }

  parameter {
    name  = "max_connections"
    value = "3000"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
  }

  parameter {
    name  = "innodb_io_capacity"
    value = "2000"
  }

  parameter {
    name  = "innodb_io_capacity_max"
    value = "4000"
  }
}

resource "aws_db_option_group" "mysql" {
  name                     = var.option_group_name
  option_group_description = "Terraform Option Group"
  engine_name              = "mysql"
  major_engine_version     = "8.0"
}
