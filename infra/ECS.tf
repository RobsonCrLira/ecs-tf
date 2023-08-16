# module "ecs" {
#   source       = "terraform-aws-modules/ecs/aws"
#   cluster_name = var.ambiente
#   cluster_configuration = {
#     execute_command_configuration = {
#       logging = "OVERRIDE"
#       log_configuration = {
#         cloud_watch_log_group_name = "/aws/ecs/"
#       }
#     }
#   }
#   cluster_settings = {
#     "name" : "containerInsights",
#     "value" : "enabled"
#   }
# }
resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.ambiente

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecs-docker" {
  family                   = "ecs-docker"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode(
    [
      {
        "name"      = "production"
        "image"     = "475454300635.dkr.ecr.us-east-1.amazonaws.com/production-repository:latest"
        "cpu"       = 256
        "memory"    = 512
        "essential" = true
        "portMappings" = [
          {
            "containerPort" = 80
            "hostPort"      = 80
            "protocol"      = "tcp",
            "appProtocol"   = "http"
          }
        ]
      }
    ]
  )
}

resource "aws_ecs_service" "ecs-docker" {
  name            = "ecs-docker"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs-docker.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "production"
    container_port   = 80
  }

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.private.id]
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}