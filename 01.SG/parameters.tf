data "aws_ssm_parameter" "this" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

resource "aws_ssm_parameter" "db-sg" {
  name  = "/${var.project_name}/${var.environment}/db_sg_id"
  type  = "String"
  value = module.sg-made-easy-db.sg_id
}

resource "aws_ssm_parameter" "be-sg" {
  name  = "/${var.project_name}/${var.environment}/be_sg_id"
  type  = "String"
  value = module.sg-made-easy-be.sg_id
}

resource "aws_ssm_parameter" "fe-sg" {
  name  = "/${var.project_name}/${var.environment}/fe_sg_id"
  type  = "String"
  value = module.sg-made-easy-fe.sg_id
}

resource "aws_ssm_parameter" "bastion-sg" {
  name  = "/${var.project_name}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.sg-made-easy-bastion.sg_id
}

resource "aws_ssm_parameter" "vpn-sg" {
  name  = "/${var.project_name}/${var.environment}/vpn_sg_id"
  type  = "String"
  value = module.sg-made-easy-vpn.sg_id
}

resource "aws_ssm_parameter" "app_alb-sg" {
  name  = "/${var.project_name}/${var.environment}/app_alb_sg_id"
  type  = "String"
  value = module.sg-made-easy-app_alb.sg_id
}

resource "aws_ssm_parameter" "web_app_alb-sg" {
  name  = "/${var.project_name}/${var.environment}/web_app_alb_sg_id"
  type  = "String"
  value = module.sg-made-easy-web_app_alb.sg_id
}