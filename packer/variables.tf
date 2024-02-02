# networking variables
variable "vpc_name" {
  type        = string
  description = "VPC Name"
}
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Values"
}
variable "public_cidr" {
  type        = list(string)
  description = "Public Subnet CIDR Values"
}
variable "us_az" {
  type        = list(string)
  description = "Availability Zones"
}
variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}
variable "JENKINS_VERSION" {
  default = "2.414.3"
}
variable "TERRAFORM_VERSION" {
  default = "0.12.23"
}
variable "APP_INSTANCE_COUNT"{
  default = "0"
}