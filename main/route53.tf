resource "aws_route53_record" "admin" {
  name            = format("user.%s", module.ctx.domain)
  zone_id         = data.aws_route53_zone.public.zone_id
  type            = "CNAME"
  ttl             = "300"
  records         = [module.alb.lb_dns_name]
  allow_overwrite = true
}
