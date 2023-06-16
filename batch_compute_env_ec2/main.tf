resource "aws_batch_compute_environment" "this" {
  compute_environment_name = var.compute_env_name
  compute_resources {

    type                = "EC2"
    instance_role       = var.instance_profile
    min_vcpus           = 0
    max_vcpus           = 5000
    desired_vcpus       = var.desired_vcpus
    allocation_strategy = "BEST_FIT"
    instance_type = [
      "optimal",
    ]
    security_group_ids = [data.aws_security_group.default.id]
    subnets            = [data.aws_subnet.public_subnet.id]
    launch_template {
      launch_template_name = aws_launch_template.main_template.name
      version              = 1
    }
  }

  service_role = var.service_role_arn
  type         = "MANAGED"
  state        = "ENABLED"
  depends_on   = [var.service_role_name]

  tags = {
    Name = var.batch_name
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_template" "main_template" {
  image_id               = "ami-0f260fe26c2826a3d"
  vpc_security_group_ids = [data.aws_security_group.default.id]
  instance_type          = "t2.micro"
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 30
      volume_type           = "gp2"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.environment
    }
  }
}

