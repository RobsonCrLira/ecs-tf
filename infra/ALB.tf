resource "aws_lb" "alb_ecs" {
  name               = "alb-ecs"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_ecs.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "http-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = aws_lb.alb_ecs.dns_name
}