# ECS ami

data "aws_ami" "ecs" {
    most_recent = true
    filter {
        name = "name"
        values = ["amzn-ami-*-amazon-ecs-optimized"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["591542846629"]
}

#
# ECS Cluster
#

resource "aws_ecs_cluster" "cluster" {
    name = var.cluster_name
}

#
# Launch Template
#

resource "aws_launch_template" "cluster" {
    name_prefix = "ecs-${var.cluster_name}-launchtemplate"
    image_id = data.aws_ami.ecs.id
    instance_type = var.instance_type
    key_name = var.ssh_key_name
    iam_instance_profile { 
        arn = aws_iam_instance_profile.cluster-ec2-role.arn
         }
    vpc_security_group_ids = [aws_security_group.cluster.id]
    user_data = templatefile("${path.module}/templates/ecs_init.tpl", {
        cluster_name = var.cluster_name
    })
    metadata_options {
        http_endpoint = "enabled"
        http_tokens   = "required"
  }
}


#
# Autoscaling Group
#

resource "aws_autoscaling_group" "cluster" {
    name_prefix = "ecs-${var.cluster_name}-autoscaling"
    vpc_zone_identifier = split(",", var.vpc_subnets)
    min_size = var.ecs_minsize
    max_size = var.ecs_maxsize
    desired_capacity = var.ecs_desired_capacity
    
    launch_template {
      id = aws_launch_template.cluster.id
      version = "$Latest"
    }
    tag {
        key = "Name"
        value = "${var.cluster_name}-ecs"
        propagate_at_launch = true
    }

}
