variable "ami_image_owner" {}
variable "ami_image_name" {}
variable "tag_name" {}
variable "instance_type" {}
variable "subnet_id"{}
variable "security_group_id"{}
variable "enable_public_ip_address" {}
variable "user_data_install_jenkins" {}
variable "vm_public_key" {}

output "piblic_ip" {
    value = aws_instance.jenkins_server.public_ip
}
output "ssh_connection_string" {
    value = format("%s%s", "ssh -i /home/azams/.ssh/vmaws ubuntu@", aws_instance.jenkins_server.public_ip)
}



data "aws_ami" "ubuntu_server_ami" {
    most_recent = true
    owners = [var.ami_image_owner]
    filter {
        name = "name"
        values = [var.ami_image_name]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
}

output "ami_id" {
  value = data.aws_ami.ubuntu_server_ami.id
}

resource "aws_key_pair" "vmaws" {
  key_name   = "vmaws"
  public_key = var.vm_public_key
}

output "key_name" {
  value = aws_key_pair.vmaws.key_name
}

resource "aws_instance" "jenkins_server" {
    ami = data.aws_ami.ubuntu_server_ami.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.security_group_id
    user_data = var.user_data_install_jenkins
    associate_public_ip_address = var.enable_public_ip_address
    tags = {
        Name = var.tag_name
    }
    
    key_name = aws_key_pair.vmaws.key_name
}
