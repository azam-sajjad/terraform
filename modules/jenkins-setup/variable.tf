# networking variables
variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR Values"
}
variable "vpc_name" {
  type        = string
  description = "Devops Project tr-jenkins VPC 1"
}
variable "public_cidr" {
  type        = list(string)
  description = "Public Subnet CIDR Values"
}
variable "us_az" {
  type        = list(string)
  description = "Availability Zones"
}