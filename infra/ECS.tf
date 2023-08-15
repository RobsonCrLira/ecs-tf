module "ecs" {
  source             = "terraform-aws-modules/ecs/aws"
  name               = var.ambiente
  container_insights = true
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
      weight            = 1
    }
  ]
}