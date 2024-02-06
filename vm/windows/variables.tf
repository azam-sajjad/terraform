variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
    default = "us-east-1"
}
variable "AMI" {
    type = map
    default = {
        us-east-1 = "ami-00d990e7e5ece7974"
        us-east-2 = "ami-09694bfab577e90b0"
        us-west-1 = "ami-0353faff0d421c70e"
        us-west-2 = "ami-035bf26fb18e75d1b"
    }
}

variable "PATH_TO_PRIVATE_KEY" {
    default = "/home/azams/.ssh/vmaws"
}
variable "PATH_TO_PUBLIC_KEY" {
    default = "/home/azams/.ssh/vmaws.pub"
}
variable "INSTANCE_USERNAME" {
    default = "Terraform"
}
variable "INSTANCE_PASSWORD" {}

# Terraform Variable Types
# List(type) [0,1,5,5,2] always ordered
# Set(type) [0,1,2,5] always unique
# Map(type) {"key" = "value"}
# Object({<ATTR NAME> = <TYPE, ...}) like MAP
# Tuple([<TYPE>, ...]) like LIST with different types


# variable "myvar" {
#     type = string
#     default = "hello terraform"
# }

# variable "mymap" {
#     type = map(string)
#     default = {
#         mykey = "my value"
#     }
# }

# variable "mylist" {
#     type = list 
#     default = [1,2]
# }

