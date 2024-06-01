module "vpn-made-easy" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  key_name = "vpn-001"
  name     = "${var.project_name}-${var.environment}-vpn"

  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id                   = element(split(",", data.aws_ssm_parameter.pub_subnet_ids.value), 0)
  ami                         = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}