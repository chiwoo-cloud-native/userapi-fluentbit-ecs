locals {
  sg_name = format("%s-%s-codebuild-sg", local.name_prefix, var.app_name)
}

resource "aws_security_group" "this" {
  name        = local.sg_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, {
    Name = local.sg_name
  })
}

resource "aws_security_group_rule" "out_any" {
  type              = "egress"
  description       = "Egress Any"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "in_http" {
  type              = "ingress"
  description       = "Public HTTP"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "in_https" {
  type              = "ingress"
  description       = "Public HTTPS"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}
