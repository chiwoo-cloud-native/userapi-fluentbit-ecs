locals {
  name_prefix = var.context.name_prefix
  tags        = var.context.tags
  ecr_name    = format("%s-%s-ecr", local.name_prefix, var.app_name)
  enabled_ecr_encryption = var.ecr_encryption_type != null && var.ecr_kms_key != null ? true : false
}

resource "aws_ecr_repository" "this" {
  name                 = local.ecr_name
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete_enabled

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  dynamic "encryption_configuration" {
    for_each = local.enabled_ecr_encryption ? ["true"] : []
    content {
      encryption_type = var.ecr_encryption_type
      kms_key         = var.ecr_kms_key
    }
  }

  tags = merge(local.tags, {
    Name = local.ecr_name
  })
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.ecr_image_limit > 0 ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = format("keep last %s images", var.ecr_image_limit)
        action       = {
          type = "expire"
        }
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.ecr_image_limit
        }
      }
    ]
  })
}
