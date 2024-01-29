variable "vpc_id"{}
variable "jenkins_ec2_sg_name"{}
variable "jenkins_ec2_sg_name_portal"{}


output "jenkins_security_group_id" {
    value = aws_security_group.jenkins_allow.id
}
output "jenkins_security_group_id_portal" {
    value = aws_security_group.jenkins_allow_portal.id
}

locals {
    ingress = [
        {
            port = "22"
            description = "allow ssh"
        },
        {
            port = "80"
            description = "allow http"
        },
        {
            port = "443"
            description = "allow https"
        }
    ]
}



resource "aws_security_group" "jenkins_allow" {
    name = var.jenkins_ec2_sg_name
    vpc_id = var.vpc_id
    tags = {
        Name = "sg_to_allow_traffic_for_jenkins_ec2"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    dynamic "ingress" {
        for_each = local.ingress
        content {
            description = ingress.value.description
            to_port = ingress.value.port
            from_port = ingress.value.port 
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
    
}

resource "aws_security_group" "jenkins_allow_portal" {
    name = var.jenkins_ec2_sg_name_portal
    description = "allow port 8080 for testing"
    vpc_id = var.vpc_id
    tags = {
        Name = "sg_for_testing"
    }
    ingress {
        description = "allow port 8080"
        to_port = "8080"
        from_port = "8080"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]     
    }
}