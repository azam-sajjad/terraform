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

module "jenkins_server" {
    source = "./jenkins_server"
    ami_image_owner = "099720109477"
    ami_image_name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    tag_name = "Jenkins:TF:Ubuntu EC2"
    instance_type = "t3.micro"
    security_group_id = [module.security_groups.jenkins_security_group_id, module.security_groups.jenkins_security_group_id_portal]
    subnet_id = tolist(module.networking.public_subnets)[0]
    enable_public_ip_address = true
    user_data_install_jenkins = templatefile("./jenkins_script/install.sh", {})
    vm_public_key = templatefile("/home/azams/.ssh/vmaws.pub", {})
}