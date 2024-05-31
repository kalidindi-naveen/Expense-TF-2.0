data "aws_ssm_parameter" "this" {
  name = "/expense/dev/vpc_id"
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