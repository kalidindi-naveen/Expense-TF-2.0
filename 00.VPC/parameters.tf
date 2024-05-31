resource "aws_ssm_parameter" "this" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc-made-easy.vpc_id
}

### ["id1","id2"] List Format
### id1,id2 StringList Format
resource "aws_ssm_parameter" "pub_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/pub_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc-made-easy.pub_subnet_ids)
}

resource "aws_ssm_parameter" "pri_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/pri_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc-made-easy.pri_subnet_ids)
}

resource "aws_ssm_parameter" "db_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc-made-easy.pub_subnet_ids)
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"
  type  = "String"
  value = module.vpc-made-easy.db_subnet_group_name
}

resource "aws_ssm_parameter" "db_subnet_group_id" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_id"
  type  = "String"
  value = module.vpc-made-easy.db_subnet_group_id
}