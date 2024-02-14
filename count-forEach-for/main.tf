provider "aws" {
  region = "us-east-1"
}

variable "subnet_cidr_blocks" {
    description = "CIDR blocks for the subnets."
    type = list(string)
    default = ["10.10.0.0/24","10.10.2.0/24"]
}

resource "aws_vpc" "main" {
    cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "example" {
    for_each = toset(var.subnet_cidr_blocks)
    vpc_id = aws_vpc.main.id
    cidr_block = each.value
    availability_zone = "us-east-1a"
}

output "all_subnets" {
    value = aws_subnet.example
}
output "all_ids" {
    value = values(aws_subnet.example)[*].id
}

# locals {
#     web_servers = {
#         nginx-0 = {
#             instance_type = "t3.micro"
#             availability_zone = "us-east-1a"
#         }
#         nginx-1 = {
#             instance_type = "t3.small"
#             availability_zone = "us-east-1a"
#         }
#     }
# }

# resource "aws_instance" "web" {
#     for_each = local.web_servers
    
#     ami = "ami-0e731c8a588258d0d"
#     instance_type = each.value.instance_type
#     availability_zone = each.value.availability_zone
#     tags = {
#         Name = each.key
#     }


    
# }





variable "vpcs" {
    description = "A list of VPCs."
    default = ["main", "database"]
}

output "New_vpcs" {
    value = [for vpc in var.vpcs : title(vpc)]
}
output "New_vpcs_2" {
    value = [for vpc in var.vpcs : title(vpc) if length(vpc) < 5]
} 






variable "my_vpcs" {
    default = {
        main = "main vpc"
        database = "vpc for database"
    }
}

output "my_vpcs_tolist" {
    value = [for k, v in var.my_vpcs : "${k} is the ${v}"]
}
# + my_vpcs     = [
#       + "database is the vpc for database",
#       + "main is the main vpc",
#     ]
# takes a MAP and returns a LIST of STRINGS



output "my_vpcs_tomap" {
    value = {for k, v in var.my_vpcs : title(k) => title(v)}
}
# if you want your output to be a MAP instead of a LIST
#   + my_vpcs_tomap  = {
#       + Database = "Vpc For Database"
#       + Main     = "Main Vpc"
#     }



#######################################################################################
#######################################################################################

# CONDITIONAL EXPRESSIONS - IF with count,for_each,for & if

#######################################################################################
#######################################################################################

# count
variable "enable_database_vpc" {
    default = true
    }

resource "aws_vpc" "database" {
    # count = <CONDITION> ? <TRUE_VALUE> : <FALSE_VAL>
    count = var.enable_database_vpc ? 1 : 0
    cidr_block = "10.11.0.0/16"
}




# CREATE IF-THEN STATEMENT

variable "enable_public" {
    default = true
}

resource "aws_subnet" "public" {
    count = var.enable_public ? 1 : 0

    vpc_id = aws_vpc.main.id
    cidr_block = "10.10.1.0/24"
}

resource "aws_subnet" "private" {
    count = var.enable_public ? 0 : 1  # <--------switch

    vpc_id = aws_vpc.main.id
    cidr_block = "10.10.2.0/24"
}

# 2 approaches to generate an output

output "subnet_id" {
    value = (
        var.enable_public
        ? aws_subnet.public[0].id
        : aws_subnet.private[0].id
    )
}

# better way use ONE & CONCAT functions
# CONCAT = takes two or more lists and combines them into a single list
# ONE = takes a list as input - returns null if list is empty, returns one element is list has one element, returns error if list has one or more elements 
output "subnet_id_v2" {
    value = one(concat(
        aws_subnet.public[*].id,
        aws_subnet.private[*].id
    ))
}

