module "networking" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    public_cidr = var.public_cidr
    us_availability_zone = var.us_az
}

# module "security_group" {

# }

# module "jenkins_ec2" {

# }

# module "target_group" {

# }

# module "alb" {

# }
