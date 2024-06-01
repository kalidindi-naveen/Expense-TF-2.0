module "be-made-easy" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-be"
  ami  = data.aws_ami.ami_id.id

  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [data.aws_ssm_parameter.be_sg_id.value]
  subnet_id              = element(split(",", data.aws_ssm_parameter.pri_subnet_ids.value), 0)

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-be"
  })
}

resource "null_resource" "this" {
  triggers = {
    instance_id = module.be-made-easy.id
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = module.be-made-easy.private_ip
  }
  provisioner "file" {
    source      = "backend.sh"
    destination = "/tmp/backend.sh"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name = "be-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        module.be-made-easy.private_ip
      ]
    }
  ]
}