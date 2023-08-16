resource "aws_security_group" "alb" {
  name        = "SG-ecs-ALB"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "SG-ecs-ALB"
  }
}

resource "aws_security_group" "private" {
  name        = "SG-ecs-private"
  description = "Security group for private"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "SG-ecs-private"
  }
}

resource "aws_security_group_rule" "sg-alb-ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "sg-alb-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "private-ecs-alb-ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.private.id
}

resource "aws_security_group_rule" "private-ecs-alb-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private.id
}