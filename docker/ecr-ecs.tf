resource "aws_ecr_repository" "myapp" {
    name = "myapp"
}

resource "aws_ecs_cluster" "myapp" {
  name = "myapp-cluster"

#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }
}
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
data "aws_key_pair" "vmaws" {
  key_name           = "vmaws"
  include_public_key = true
}

resource "aws_launch_template" "ecs-launchtemplate" {
  name_prefix = "ecs-launchtemplate"
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = data.aws_key_pair.vmaws.key_name
  # iam_instance_profile = aws_iam_instance_profile.ecs-ec2-role.name
  vpc_security_group_ids = ["${aws_security_group.ecs-securitygroup.id}"]
  # user_data = "#!/bin/bash\necho 'ECS_CLUSTER=myapp-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs-autoscaling" {
  name = "ecs-autoscaling"
  vpc_zone_identifier = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  min_size = 1
  max_size = 1
  desired_capacity = 1
  launch_template {
    id = aws_launch_template.ecs-launchtemplate.id
  }

}