module "networking" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    public_cidr = var.public_cidr
    us_availability_zone = var.us_az
}

module "security_groups" {
    source = "./security_groups"
    vpc_id = module.networking.vpc_id
    jenkins_ec2_sg_name = "jenkins_allow"
    jenkins_ec2_sg_name_portal = "jenkins_allow_portal"
}

module "iam" {
    source = "./iam"
}

module "servers" {
    source = "./servers"
    ami_image_owner = "099720109477"
    ami_image_name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    tag_name = "Jenkins:TF:Ubuntu s3"
    instance_type = "t3.micro"
    security_group_id = [module.security_groups.jenkins_security_group_id, module.security_groups.jenkins_security_group_id_portal]
    security_group_id_for_app = [module.security_groups.jenkins_security_group_id]
    subnet_id = tolist(module.networking.public_subnets)[0]
    user_data_install_jenkins = data.cloudinit_config.cloudinit_jenkins.rendered
    vm_public_key = templatefile("/home/azams/.ssh/vmaws.pub", {})
    private_ip = "10.1.1.10"
    instance_profile = module.iam.instance_profile_name
    APP_INSTANCE_COUNT = var.APP_INSTANCE_COUNT
    INSTANCE_DEVICE_NAME = var.INSTANCE_DEVICE_NAME
    us_availability_zone = var.us_az[0]
}
