data "aws_caller_identity" "current" {}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_prefix}-vpc"]
  }
}

data "aws_iam_role" "ecs" {
  name = "${local.project}EcsTaskExecutionRole"
}

data "aws_subnets" "app" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${local.name_prefix}-app-*"]
  }
}

data "aws_ecs_cluster" "this" {
  cluster_name = "${local.name_prefix}-demo-ecs"
}

data "aws_kms_key" "this" {
  key_id = "alias/${local.name_prefix}-main-kms"
}

# Security Group ----------
data "aws_security_group" "public_alb_sg" {
  name = "${local.name_prefix}-pub-alb-sg"
}

