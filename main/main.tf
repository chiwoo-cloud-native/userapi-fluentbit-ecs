# 네이밍 및 Tagging 속성을 구성
module "ctx" {
  source  = "../modules/context/"
  context = var.context
}

locals {
  name_prefix = module.ctx.name_prefix
  tags        = module.ctx.tags
  vpc_name    = "${module.ctx.name_prefix}-vpc"
}

# VPC 리소스 생성
module "vpc" {
  source = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  name   = local.name_prefix
  cidr   = "172.176.0.0/16"

  azs                  = ["apse1-az1", "apse1-az2"]
  public_subnets       = ["172.176.11.0/24", "172.176.12.0/24"]
  public_subnet_suffix = "pub"

  private_subnets       = ["172.176.21.0/24", "172.176.22.0/24"]
  private_subnet_suffix = "app"

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = merge(local.tags, {})

  vpc_tags         = { Name = local.vpc_name }
  igw_tags         = { Name = format("%s-igw", local.name_prefix) }
  nat_gateway_tags = { Name = format("%s-nat", local.name_prefix) }
}

# ALB 서비스 구성
module "alb" {
  source     = "../modules/alb/"
  context    = module.ctx.context
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]
}

# ECS 서비스 구성
module "ecs" {
  source       = "../modules/ecs/"
  context      = module.ctx.context
  cluster_name = "demo"
  depends_on   = [module.vpc]
}
