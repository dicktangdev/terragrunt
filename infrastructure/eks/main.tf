provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "~> 19.15"
  cluster_version           = var.cluster_version
  cluster_name              = var.cluster_name
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  cluster_endpoint_public_access = var.public_access

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  enable_irsa = true

  cluster_addons = {
    coredns = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
      configuration_values = jsonencode({
        nodeSelector = var.coredns_selector.nodeSelector
      })
    }
    kube-proxy = {
      addon_version     = "v1.27.8-eksbuild.4"
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      addon_version     = "v1.16.2-eksbuild.1"
      most_recent       = true
      before_compute    = true
      resolve_conflicts = "OVERWRITE"
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_IP_TARGET           = "1"
          MINIMUM_IP_TARGET        = "1"
        }
      })
    }
    aws-ebs-csi-driver = {
      addon_version     = "v1.27.0-eksbuild.1"
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_security_group_additional_rules = {
    ingress_internal = {
      # TODO: limit to CIDRs of subnets running VPN?
      description = "allow all internal addresses to access control plane"
      protocol    = "-1"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [
        "10.0.0.0/8",
        "172.16.0.0/12",
        "192.168.0.0/16",
      ]
    }
    egress_nodes_ephemeral_ports_tcp = {
      description = "To node 1025-65535"
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535
      type        = "egress"

      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_control-plane = {
      description = "control-plane2node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"

      source_cluster_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5d.large", "m5zn.large"]
  }

  node_security_group_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = null
  } # refer to the issue - https://stackoverflow.com/questions/74687452/eks-error-syncing-load-balancer-failed-to-ensure-load-balancer-multiple-tagge

  eks_managed_node_groups = {
    eks-staging-node = {
      min_size       = var.min_size
      max_size       = 6
      desired_size   = var.desired_size
      instance_types = [var.eks_managed_node_groups_instance_types]
      subnet_ids     = var.subnet_ids
      capacity_type  = "ON_DEMAND"
      # bootstrap_extra_args = ["--use-max-pods=false", "--max-pods=110"] did not test, but not working refer to https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2551
      enable_bootstrap_user_data = false

      pre_bootstrap_user_data = <<-EOT
        #!/bin/bash
        LINE_NUMBER=$(grep -n "KUBELET_EXTRA_ARGS=\$2" /etc/eks/bootstrap.sh | cut -f1 -d:)
        REPLACEMENT="\ \ \ \ \ \ KUBELET_EXTRA_ARGS=\$(echo \$2 | sed -s -E 's/--max-pods=[0-9]+/--max-pods=35/g')"
        sed -i '/KUBELET_EXTRA_ARGS=\$2/d' /etc/eks/bootstrap.sh
        sed -i "$${LINE_NUMBER}i $${REPLACEMENT}" /etc/eks/bootstrap.sh
      EOT

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 80
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            delete_on_termination = true
          }
        }
      }


      # Needed by the aws-ebs-csi-driver
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
        AmazonRoute53FullAccess           = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
        AmazonRDSFullAccess               = "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
        AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
      }
      labels = {
        capacityType = "ON_DEMAND",
        corenode     = "True"
      }
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true
  # create_aws_auth_configmap = true
  aws_auth_roles = var.aws_auth_roles

  aws_auth_users = var.aws_auth_users

  aws_auth_accounts = var.aws_auth_accounts

  tags = merge(
    var.tags,
    {
      "karpenter.sh/discovery" = var.cluster_name
    }
  )
}