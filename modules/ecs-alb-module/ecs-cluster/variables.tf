variable "cluster_name" {}
variable "aws_region"{}
variable "aws_account_id" {}
variable "log_group" {}
variable "vpc_id" {}
variable "instance_type" {}
variable "ssh_key_name" {}
variable "vpc_subnets" {}

variable "ecs_minsize" {
  default = 1
}
variable "ecs_maxsize" {
  default = 1
}
variable "ecs_desired_capacity" {
  default = 1
}
variable "enable_ssh" {
  default = false
}
variable "ssh_sg" {
  default = ""
}
variable "log_retention_days" {
  default = 0
}