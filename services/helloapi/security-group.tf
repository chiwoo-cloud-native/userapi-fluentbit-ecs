resource "aws_security_group" "this" {
  name        = format("%s-%s-sg", local.name_prefix, var.app_name)
  description = format("%s ecs service", var.app_name)
  vpc_id      = data.aws_vpc.this.id

  tags = merge(local.tags, {
    Name = format("%s-%s-sg", local.name_prefix, var.app_name)
  })

}

resource "aws_security_group_rule" "out_443" {
  type              = "egress"
  description       = "all for HTTPS"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "in" {
  type                     = "ingress"
  description              = format("Public ALB - %s", var.app_name)
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.public_alb_sg.id
  from_port                = var.port
  to_port                  = var.port
  security_group_id        = aws_security_group.this.id
}
