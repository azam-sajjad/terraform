variable "ami_image_owner" {}
variable "ami_image_name" {}
variable "tag_name" {}
variable "instance_type" {}
variable "subnet_id"{}
variable "security_group_id"{}
variable "security_group_id_for_app"{}
variable "user_data_install_jenkins" {}
variable "vm_public_key" {}
variable "private_ip" {}
variable "instance_profile" {}
variable "APP_INSTANCE_COUNT"{}
variable "INSTANCE_DEVICE_NAME"{}
variable "us_availability_zone"{}

 


output "app_public_ip" {
    value = [aws_instance.app_server.*.public_ip]
}
output "ssh_connection_string" {
    value = format("%s%s", "ssh -i /home/azams/.ssh/vmaws ubuntu@", aws_eip.server_eip.public_ip)
}
output "ami_id" {
  value = data.aws_ami.ubuntu_server_ami.id
}
output "key_name" {
  value = data.aws_key_pair.vmaws.key_name
}
output "instance_id" {
    value = aws_instance.jenkins_server.id
}
output "elastic_ip" {
    value = aws_eip.server_eip.public_ip
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



data "aws_key_pair" "vmaws" {
  key_name   = "vmaws"
  include_public_key = true
}


resource "aws_instance" "jenkins_server" {
    ami = data.aws_ami.ubuntu_server_ami.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.security_group_id
    user_data = var.user_data_install_jenkins
    private_ip = var.private_ip
    tags = {
        Name = var.tag_name
    }
    
    key_name = data.aws_key_pair.vmaws.key_name
    iam_instance_profile = var.instance_profile
}
resource "aws_ebs_volume" "jenkins-data" {
  availability_zone = var.us_availability_zone
  size              = 20
  type              = "gp2"
  tags = {
    Name = "jenkins-data"
  }
}

resource "aws_volume_attachment" "jenkins-data-attachment" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.jenkins-data.id
  instance_id  = aws_instance.jenkins_server.id
#   skip_destroy = true
}


resource "aws_eip" "server_eip" {
    instance = "${aws_instance.jenkins_server.id}"
    domain = "vpc"
    associate_with_private_ip = var.private_ip
}

resource "aws_instance" "app_server" {
  count         = var.APP_INSTANCE_COUNT
  ami           = data.aws_ami.ubuntu_server_ami.id
  instance_type = "t3.micro"

  # the VPC subnet
  subnet_id = var.subnet_id

  # the security group
  vpc_security_group_ids = var.security_group_id_for_app

  # the public SSH key
  key_name = data.aws_key_pair.vmaws.key_name
}