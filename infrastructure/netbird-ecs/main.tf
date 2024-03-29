# ECS resources
resource "aws_ecs_cluster" "wiretrustee" {
  name = var.name
}

resource "aws_ecs_service" "wiretrustee" {
  name                = var.name
  cluster             = aws_ecs_cluster.wiretrustee.id
  task_definition     = aws_ecs_task_definition.wiretrustee.arn
  scheduling_strategy = "DAEMON"
}

resource "aws_ecs_task_definition" "wiretrustee" {
  family = var.name
  container_definitions = jsonencode([
    {
      name              = var.name
      image             = "wiretrustee/wiretrustee:latest"
      essential         = true
      memoryReservation = 64
      privileged        = true
      environment = [
        {
          name  = "WT_LOG_FILE"
          value = "console"
        },
        {
          name  = "WT_LOG_LEVEL"
          value = var.wt_log_level
        },
        {
          name  = "WT_SETUP_KEY"
          value = var.wt_setup_key
        }
      ]
      mountPoints = [
        {
          containerPath = "/etc/wiretrustee"
          sourceVolume  = var.name
        }
    ] }
  ])
  network_mode = "host"
  volume {
    name      = var.name
    host_path = "/etc/wiretrustee"
  }
}

# EC2 resources

data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

data "aws_iam_policy_document" "ecs_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

locals {
  userdata = <<-USERDATA
    #!/bin/bash
    echo "ECS_CLUSTER=${aws_ecs_cluster.wiretrustee.name}" >> /etc/ecs/ecs.config
  USERDATA
}

resource "aws_iam_role" "ecs" {
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  name_prefix = var.name
}

resource "aws_iam_instance_profile" "ecs" {
  role        = aws_iam_role.ecs.name
  name_prefix = var.name
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ecs" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_launch_template" "wiretrustee" {
  name_prefix   = var.name
  image_id      = data.aws_ami.ecs.image_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }
  key_name = aws_key_pair.ecs.key_name
  vpc_security_group_ids = [
    var.vpc_default_security_group_id
  ]
  user_data = base64encode(local.userdata)
}

data "aws_default_tags" "wiretrustee" {}


resource "aws_autoscaling_group" "wiretrustee" {
  name_prefix         = var.name
  desired_capacity    = 1
  max_size            = 2
  min_size            = 0
  vpc_zone_identifier = var.vpc_private_subnets
  launch_template {
    id      = aws_launch_template.wiretrustee.id
    version = "$Latest"
  }
  dynamic "tag" {
    for_each = data.aws_default_tags.wiretrustee.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
