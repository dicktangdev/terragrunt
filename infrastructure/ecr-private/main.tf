resource "aws_ecr_repository" "ecr" {
  name                 = var.repo_name
  image_tag_mutability = var.mutability

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}