module "sg-made-easy-db" {
  source         = "git::https://github.com/kalidindi-naveen/Learn-TF-Modules//10.Terraform-AWS-SG?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "db"
  vpc_id         = data.aws_ssm_parameter.this.value
  sg_description = "SG For DB"
  ingress        = var.ingress
  common_tags    = var.common_tags
}

module "sg-made-easy-be" {
  source         = "git::https://github.com/kalidindi-naveen/Learn-TF-Modules//10.Terraform-AWS-SG?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "be"
  vpc_id         = data.aws_ssm_parameter.this.value
  sg_description = "SG For BE"
  ingress        = var.ingress
  common_tags    = var.common_tags
}

module "sg-made-easy-fe" {
  source         = "git::https://github.com/kalidindi-naveen/Learn-TF-Modules//10.Terraform-AWS-SG?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "fe"
  vpc_id         = data.aws_ssm_parameter.this.value
  sg_description = "SG For FE"
  ingress        = var.ingress
  common_tags    = var.common_tags
}

module "sg-made-easy-bastion" {
  source         = "git::https://github.com/kalidindi-naveen/Learn-TF-Modules//10.Terraform-AWS-SG?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "bastion"
  vpc_id         = data.aws_ssm_parameter.this.value
  sg_description = "SG For bastion"
  ingress        = var.ingress
  common_tags    = var.common_tags
}

module "sg-made-easy-app_alb" {
  source         = "git::https://github.com/kalidindi-naveen/Learn-TF-Modules//10.Terraform-AWS-SG?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "app_alb"
  vpc_id         = data.aws_ssm_parameter.this.value
  sg_description = "SG For app_alb"
  ingress        = var.ingress
  common_tags    = var.common_tags
}

module "sg-made-easy-web_app_alb" {
  source         = "git::https://github.com/kalidindi-naveen/Learn-TF-Modules//10.Terraform-AWS-SG?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "web_app_alb"
  vpc_id         = data.aws_ssm_parameter.this.value
  sg_description = "SG For web_app_alb"
  ingress        = var.ingress
  common_tags    = var.common_tags
}

module "sg-made-easy-vpn" {
  source         = "git::https://github.com/kalidindi-naveen/Learn-TF-Modules//10.Terraform-AWS-SG?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "vpn"
  vpc_id         = data.aws_ssm_parameter.this.value
  sg_description = "SG For vpn"
  ingress        = var.vpn_sg_rules
  common_tags    = var.common_tags
}