#
# ECS Service Role
#

resource "aws_iam_role" "cluster-service-role" {
    name = "ecs-service-role-${var.cluster_name}"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "cluster-service-role" {
    name = "${var.cluster_name}-policy"
    role = aws_iam_role.cluster-service-role.name
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow",
                Resource = "*",
                Action = [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:Describe*",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets" 
                ]
            }
        ]
    })
}


#
# IAM EC2 Role
#

resource "aws_iam_role" "cluster-ec2-role" {
    name = "ecs-${var.cluster_name}-ec2-role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "cluster-ec2-role" {
    name = "ecs-${var.cluster_name}-ec2-role-policy"
    role = aws_iam_role.cluster-ec2-role.name
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow",
            Resource = "*",
            Action = [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"               
            ]
        },
        {
            Effect = "Allow",
            Resource = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${var.log_group}:*",
            Action = [
                "logs:*"
            ]
        }
        ]
    })
}

resource "aws_iam_instance_profile" "cluster-ec2-role" {
    name = "ecs-${var.cluster_name}-ec2-role"
    role = aws_iam_role.cluster-ec2-role.name
}