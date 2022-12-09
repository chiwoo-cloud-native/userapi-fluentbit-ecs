resource "aws_route53_record" "admin" {
  name            = format("hello.%s", module.ctx.domain)
  zone_id         = data.aws_route53_zone.public.zone_id
  type            = "CNAME"
  ttl             = "300"
  records         = [data.aws_lb.this.dns_name]
  allow_overwrite = true
}
