### DB
resource "aws_security_group_rule" "db-be" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-be.sg_id
  security_group_id        = module.sg-made-easy-db.sg_id
}

resource "aws_security_group_rule" "db-bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-bastion.sg_id
  security_group_id        = module.sg-made-easy-db.sg_id
}

resource "aws_security_group_rule" "db-vpn" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-vpn.sg_id
  security_group_id        = module.sg-made-easy-db.sg_id
}

### BE
resource "aws_security_group_rule" "be-app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-app_alb.sg_id
  security_group_id        = module.sg-made-easy-be.sg_id
}

resource "aws_security_group_rule" "be-vpn-ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-vpn.sg_id
  security_group_id        = module.sg-made-easy-be.sg_id
}

resource "aws_security_group_rule" "be-vpn-http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-vpn.sg_id
  security_group_id        = module.sg-made-easy-be.sg_id
}

resource "aws_security_group_rule" "be-bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-bastion.sg_id
  security_group_id        = module.sg-made-easy-be.sg_id
}

### FE
resource "aws_security_group_rule" "fe-public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.sg-made-easy-fe.sg_id
}

resource "aws_security_group_rule" "fe-be" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-be.sg_id
  security_group_id        = module.sg-made-easy-fe.sg_id
}

resource "aws_security_group_rule" "fe-bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-bastion.sg_id
  security_group_id        = module.sg-made-easy-fe.sg_id
}

### Bastion
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.sg-made-easy-bastion.sg_id
}

### App ALB
resource "aws_security_group_rule" "app_alb-vpn" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.sg-made-easy-vpn.sg_id
  security_group_id        = module.sg-made-easy-app_alb.sg_id
}