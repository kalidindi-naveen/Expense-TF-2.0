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
    source      = "${var.common_tags.Component}.sh"
    destination = "/tmp/${var.common_tags.Component}.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.common_tags.Component}.sh",
      "sudo sh /tmp/${var.common_tags.Component}.sh ${var.common_tags.SERVER} ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "stop-be" {
  instance_id = module.be-made-easy.id
  state       = "stopped"
  # stop the serever only when null resource provisioning is completed
  depends_on = [null_resource.this]
}

resource "aws_ami_from_instance" "stop-be" {
  name               = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  source_instance_id = module.be-made-easy.id
  depends_on         = [aws_ec2_instance_state.stop-be]
}

resource "null_resource" "backend_delete" {
  triggers = {
    instance_id = module.be-made-easy.id
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = module.be-made-easy.private_ip
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.be-made-easy.id}"
  }

  depends_on = [aws_ami_from_instance.stop-be]
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