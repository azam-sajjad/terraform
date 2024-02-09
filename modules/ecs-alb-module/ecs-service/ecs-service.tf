#
# ECR
#

resource "aws_ecr_repository" "ecs-service" {
    count = length(var.containers) == 0 && var.existing_ecr == "" ? 1 : 0
    name = var.ecr_prefix == "" ? var.application_name : "${var.ecr_prefix}/{var.application_name}"
    image_scanning_configuration {
      scan_on_push = true
    }
}

#
# get latest active revision
#
data "aws_ecs_task_definition" "ecs-service" {
    task_definition = aws_ecs_task_definition.ecs-service-taskdef.arn != "" ? aws_ecs_task_definition.ecs-service-taskdef.family : ""
}

#
# Task Definition
#

resource "aws_ecs_task_definition" "ecs-service-taskdef" {
    family = var.application_name
    container_definitions = templatefile("${path.module}/ecs-service.json.tpl", local.template-vars)
    task_role_arn = var.task_role_arn
    execution_role_arn = var.execution_role_arn
    network_mode = var.launch_type == "FARGATE" ? "awsvpc" : "bridge"
    cpu = var.launch_type == "FARGATE" ? var.cpu_reservation : null
    memory = var.launch_type == "FARGATE" ? var.memory_reservation : null
    dynamic "volume" {
        for_each = var.volumes
        content {
            name = volume.value.name
            dynamic "efs_volume_configuration" {
                for_each = length(volume.value.efs_volume_configuration) > 0 ? [volume.value.efs_volume_configuration] : []
                content {
                    file_system_id = efs_volume_configuration.value.file_system_id
                    transit_encryption = efs_volume_configuration.value.transit_encryption
                    root_directory = efs_volume_configuration.value.root_directory
                    dynamic "authorization_config" {
                        for_each = efs_volume_configuration.value.authorization_config !=null ? (length(efs_volume_configuration.value.authorization_config) > 0 ? [efs_volume_configuration.value.authorization_config] : []) : []
                        content {
                            access_point_id = authorization_config.value.access_point_id
                            iam             = authorization_config.value.iam
                        }
                    }
                }

            }
        }
    }

}

#
# Target
# 

resource "aws_ecs_service" "ecs-service" {
    name = var.application_name
    cluster = var.cluster_arn
    task_definition = 
    iam_role = var.launch_type != "FARGATE" ? var.service_role_arn : null
    desired_count = var.desired_count
    
    dynamic "network_configuration" {
        for_each = var.launch_type == "FARGATE" ? tolist([var.launch_type]) : []
        content {
            security_groups = concat([aws_security_group.ecs-service.id], var.task_security_groups)
            subnets = var.fargate_service_subnetids
        }

    }
    dynamic "load_balancer" {
        for_each = length(aws_lb_target_group.ecs-service) == 0 ? [] : [values(aws_lb_target_group.ecs-service)[0]] // only get first element from the target group
        content {
            target_group_arn = load_balancer.value.arn
            container_name = length(var.containers) == 0 ? var.application_name : var.exposed_container_name
            container_port = length(var.containers) == 0 ? var.application_port : var.exposed_container_port
        }
    }


    depends_on = [null_resource.alb_exists]

}

resource "null_resource" "alb_exists" {
    triggers = {
        alb_name = var.alb_arn
    }
}