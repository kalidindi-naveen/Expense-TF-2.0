resource "aws_key_pair" "vpn" {
  key_name   = "vpn"
  public_key = file("/root/.ssh/openvpn.pub")
  # ~ means windows home directory
}


module "vpn-made-easy" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name
  name     = "${var.project_name}-${var.environment}-vpn"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = element(split(",", data.aws_ssm_parameter.pub_subnet_ids.value), 0)
  ami                    = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}