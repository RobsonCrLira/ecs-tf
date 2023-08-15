terraform {
  backend "s3" {
    bucket = "terraform-state-robson"
    key    = "Prod/terraform.tfstate"
    region = "us-east-1"
  }
}