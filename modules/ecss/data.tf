data "aws_caller_identity" "current" {}

data "aws_ecs_cluster" "this" {
  cluster_name = var.cluster_name
}

data "aws_lb" "this" {
  name = var.elb_name
}

data "aws_lb_listener" "this" {
  count             = var.create_listener ? 0 : 1
  load_balancer_arn = data.aws_lb.this.arn
  port              = var.listener_port
}

