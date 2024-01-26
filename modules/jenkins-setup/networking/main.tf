variable "vpc_cidr"{}
variable "vpc_name"{}
variable "public_cidr"{}
variable "us_availability_zone"{}

output "vpc_id" {
    value = aws_vpc.jvpc.id
}

output "public_subnets" {
    value = aws_subnet.ec2_public_subnet.*.id
}

output "public_subnet_cidr_block" {
    value = aws_subnet.ec2_public_subnet.*.cidr_block
}


resource "aws_vpc" "jvpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "ec2_public_subnet" {
    count = length(var.public_cidr)
    vpc_id = aws_vpc.jvpc.id
    cidr_block = element(var.public_cidr, count.index)
    availability_zone = element(var.us_availability_zone, count.index)
    tags = {
        Name = "jenkins-setup-subnet-${count.index + 1}"
    }   
}

resource "aws_internet_gateway" "jenkins_setup_igw" {
    vpc_id = aws_vpc.jvpc.id
    tags = {
        Name = "jenkins-setup-igw"
    }
}

resource "aws_route_table" "jenkins_setup_rt" {
    vpc_id = aws_vpc.jvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_setup_igw.id
  }

  tags = {
    Name = "jenkins-setup-rt"
  }
}

resource "aws_route_table_association" "jenkins_setup_rtass" {
    count = length(aws_subnet.ec2_public_subnet)
    subnet_id = aws_subnet.ec2_public_subnet[count.index].id
    route_table_id = aws_route_table.jenkins_setup_rt.id

}