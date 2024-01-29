module "networking" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    public_cidr = var.public_cidr
    us_availability_zone = var.us_az
}

module "security_group" {
    source = "./security_group"
    vpc_id = module.networking.vpc_id
    jenkins_ec2_sg_name = "jenkins_allow"
    jenkins_ec2_sg_name_testing = "jenkins_allow_for_testing"
}

# module "jenkins_ec2" {

# }

# module "target_group" {

# }

# module "alb" {

# }
