data "aws_route53_zone" "public" {
  name = module.ctx.domain
}

data "aws_kms_key" "this" {
  key_id = "alias/${local.name_prefix}-main-kms"
}
