data "aws_ssm_parameter" "web_app_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/web_app_alb_sg_id"
}

data "aws_ssm_parameter" "pri_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/pri_subnet_ids"
}