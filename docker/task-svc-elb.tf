# app

# data "template_file" "myapp-task-definition-template" {
#     template = "${file("templates/app.json.tpl")}"
#     vars {
#         REPOSITORY_URL = "{replace("${aws_ecr_repository.myapp.repository_url}")}"
#     }
# }


resource "aws_ecs_task_definition" "myapp-task-definition" {
    family = "service"
    container_definitions = jsonencode ([
        {
            essential = true
            memory = 256
            cpu = 10
            name = "myapp"
            image = "myapp:1"
            workingDirectory = "/app"
            command = ["npm", "start"]
            portMappings = [
                {
                    containerPort = 3000
                    hostPort = 3000
                }

            ]

        }
    ])
}


resource "aws_elb" "myapp-elb" {
    name = "myapp-elb"

    listener {
        instance_port = 3000
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold = 3
        unhealthy_threshold = 3
        timeout = 30
        target = "HTTP:3000/"
        interval = 60
    }

    cross_zone_load_balancing = true
    connection_draining = true
    connection_draining_timeout = 400
    idle_timeout = 400

    subnets = [ "${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}" ]
    security_groups = [ "${aws_security_group.myapp-elb-securitygroup.id}" ]
    tags = {
      Name = "myapp-elb"
    }
}


resource "aws_ecs_service" "myapp-service" {
    name = "myapp"
    cluster = aws_ecs_cluster.myapp.id
    task_definition = aws_ecs_task_definition.myapp-task-definition.arn
    desired_count = 1
    iam_role = aws_iam_role.ecs-service-role.arn
    depends_on = [ aws_iam_policy_attachment.ecs-service-attachment ]

    load_balancer {
      elb_name = aws_elb.myapp-elb.name
      container_name = "myapp"
      container_port = 3000
    }

}