data "aws_acm_certificate" "this" {
  domain = var.context.domain
  statuses = ["ISSUED"]
}

data "aws_subnets" "pub" {
  filter {
    name   = "vpc-id"
    values = [ var.vpc_id ]
  }

  filter {
    name   = "tag:Name"
    values = [ format("%s-pub*", local.name_prefix) ]
  }
}
