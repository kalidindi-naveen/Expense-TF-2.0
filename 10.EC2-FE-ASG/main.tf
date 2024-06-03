module "fe-made-easy" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-${var.common_tags.SERVER}"
  ami  = data.aws_ami.ami_id.id

  instance_type          = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [data.aws_ssm_parameter.fe_sg_id.value]
  subnet_id              = element(split(",", data.aws_ssm_parameter.pub_subnet_ids.value), 0)

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-${var.common_tags.SERVER}"
  })
}

resource "null_resource" "this" {
  triggers = {
    instance_id = module.fe-made-easy.id
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = module.fe-made-easy.private_ip
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

resource "aws_ec2_instance_state" "stop-fe" {
  instance_id = module.fe-made-easy.id
  state       = "stopped"
  # stop the serever only when null resource provisioning is completed
  depends_on = [null_resource.this]
}

resource "aws_ami_from_instance" "stop-fe" {
  name               = "${var.project_name}-${var.environment}-${var.common_tags.SERVER}"
  source_instance_id = module.fe-made-easy.id
  depends_on         = [aws_ec2_instance_state.stop-fe]
}

resource "null_resource" "fe_delete" {
  triggers = {
    instance_id = module.fe-made-easy.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.fe-made-easy.id}"
  }

  depends_on = [aws_ami_from_instance.stop-fe]
}

resource "aws_lb_target_group" "fe" {
  name     = "${var.project_name}-${var.environment}-${var.common_tags.SERVER}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_launch_template" "fe" {
  name = "${var.project_name}-${var.environment}-${var.common_tags.SERVER}"

  image_id                             = aws_ami_from_instance.stop-fe.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  update_default_version               = true # sets the latest version to default

  vpc_security_group_ids = [data.aws_ssm_parameter.fe_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name = "${var.project_name}-${var.environment}-${var.common_tags.SERVER}"
      }
    )
  }
}


resource "aws_autoscaling_group" "fe" {
  name                      = "${var.project_name}-${var.environment}-${var.common_tags.SERVER}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns         = [aws_lb_target_group.fe.arn]
  launch_template {
    id      = aws_launch_template.fe.id
    version = "$Latest"
  }
  vpc_zone_identifier = split(",", data.aws_ssm_parameter.pub_subnet_ids.value)

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-${var.common_tags.SERVER}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "fe" {
  name                   = "${var.project_name}-${var.environment}-${var.common_tags.SERVER}"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.fe.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 10.0
  }
}

resource "aws_lb_listener_rule" "fe" {
  listener_arn = data.aws_ssm_parameter.web_alb_listener_arn_https.value
  priority     = 100 # less number will be first validated

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fe.arn
  }

  condition {
    host_header {
      values = ["web-${var.environment}.${var.zone_name}"]
    }
  }
}
