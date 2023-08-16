module "production" {
  source              = "../../infra"
  ecr_repository_name = "production-repository"
  nameIAM             = "production"
  ambiente            = "production"
}

output "dns_name_alb" {
  value = "http://${module.production.alb_dns_name}"
}