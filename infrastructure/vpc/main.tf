module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                  = var.name
  cidr                  = var.cidr
  secondary_cidr_blocks = var.secondary_cidr_blocks

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  default_security_group_ingress = [
    {
      description = "Allow all traffic from the VPC"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = var.cidr
    },
    {
      description = "Allow all traffic from the same security group"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      self        = true
    }
  ]

  default_security_group_egress = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway # Use a single NAT gateway for all private subnets
  private_subnet_tags = var.private_subnet_tags
  public_subnet_tags  = var.public_subnet_tags
  tags                = var.tags
}