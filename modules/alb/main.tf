resource "aws_lb_target_group" "target_group_ec2" {
  name     = "target-group-instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb" "lb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.subnets_ids[0], var.subnets_ids[3]]
  security_groups    = [var.sg_alb]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_ec2.arn
  }
}


