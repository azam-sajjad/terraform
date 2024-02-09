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

}

resource "aws_ecs_service" "ecs-service" {
    name = var.application_name
    cluster = var.cluster_arn
    task_definition = 
    iam_role = var.launch_type != "FARGATE" ? var.service_role_arn : null
    desired_count = var.desired_count
    depends_on = [null_resource.alb_exists]

}

resource "null_resource" "alb_exists" {
    triggers = {
        alb_name = var.alb_arn
    }
}