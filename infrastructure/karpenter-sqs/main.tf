data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

resource "kubernetes_namespace" "karpenter" {
  metadata {
    annotations = {
      name = "karpenter"
    }
    name = "karpenter"
  }
}

resource "aws_sqs_queue" "karpenter" {
  message_retention_seconds = 300
  name                      = "${var.cluster_name}-karpenter"
}

#
# Node termination queue policy
#
resource "aws_sqs_queue_policy" "karpenter" {
  policy    = data.aws_iam_policy_document.node_termination_queue.json
  queue_url = aws_sqs_queue.karpenter.url
}

data "aws_iam_policy_document" "node_termination_queue" {
  statement {
    resources = [aws_sqs_queue.karpenter.arn]
    sid       = "SQSWrite"
    actions   = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }
  }
}

module "iam_assumable_role_karpenter" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.7.0"
  create_role                   = true
  role_name                     = "karpenter-controller-${var.environment}-${var.aws_region}"
  provider_url                  = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  oidc_fully_qualified_subjects = ["system:serviceaccount:${kubernetes_namespace.karpenter.id}:karpenter"]
}

resource "aws_iam_role_policy" "karpenter_contoller" {
  name = "karpenter-policy"
  role = module.iam_assumable_role_karpenter.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : [
          "ec2:DescribeSubnets",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeImages",
          "ec2:DescribeAvailabilityZones",
          "eks:DescribeCluster"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowEc2DescribeActions"
      },
      {
        "Action" : [
          "ec2:RunInstances",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:ec2:ap-east-1::image/*",
          "arn:aws:ec2:ap-east-1:101285038298:*"
        ],
        "Sid" : "AllowEc2Actions"
      },
      {
        "Action" : "iam:PassRole",
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowPassRole"
      },
      {
        "Action" : "pricing:GetProducts",
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowGetPrice"
      },
      {
        "Action" : "ssm:GetParameter",
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowGetParameters"
      },
      {
        "Action" : "eks:DescribeCluster",
        "Effect" : "Allow",
        "Resource" : "arn:aws:eks:*:101285038298:cluster/test-k8s-hongkong-x4pwym",
        "Sid" : ""
      },
      {
        "Action" : "ec2:TerminateInstances",
        "Effect" : "Allow",
        "Resource" : "arn:aws:ec2:ap-east-1:101285038298:instance/*",
        "Sid" : "ConditionalEC2Termination"
      },
      {
        "Action" : [
          "sqs:ReceiveMessage",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes",
          "sqs:DeleteMessage"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "sqs"
      }
    ]
  })
}

data "aws_iam_policy" "ssm_managed_instance" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "karpenter_ssm_policy" {
  role       = var.eks_worker_iam_role
  policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${var.cluster_name}"
  role = var.eks_worker_iam_role
}

resource "helm_release" "karpenter" {
  name      = "karpenter"
  namespace = kubernetes_namespace.karpenter.id
  chart     = "./charts/karpenter"

  # set {
  #   name  = "serviceAccount.annotations.eks.amazonaws.com/role-arn"
  #   value = var.karpenter_iam_role_arn
  # }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_karpenter.iam_role_arn
  }

  set {
    name  = "settings.aws.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }

  set {
    name  = "settings.aws.interruptionQueueName"
    value = "${var.cluster_name}-karpenter"
  }

  wait = true
}

data "kubectl_path_documents" "provisioner_manifests" {
  pattern = "./karpenter-provisioner-manifests/${var.env}/*.yaml"
  vars = {
    cluster_name = var.cluster_name
  }
}


resource "kubectl_manifest" "provisioners" {
  for_each  = data.kubectl_path_documents.provisioner_manifests.manifests
  yaml_body = each.value
}