locals {
  name_prefix = var.context.name_prefix
  tags        = var.context.tags
  ecr_name    = "${local.name_prefix}-${var.app_name}"
}

resource "aws_ecr_repository" "this" {
  name         = format("%s-ecr", local.ecr_name)
  force_delete = true
  tags         = merge(local.tags, {})
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 7 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 7
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
