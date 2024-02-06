variable "list1" {
    type = list(string)
    default = [1, 10, 9, 101, 3]
}
variable "list2" {
    type = list(string)
    default = ["apple", "pear", "banana", "mango"]
}
variable "map1" {
    type = map(number)
    default = {
        "apple" = 5
        "pear" = 3
        "banana" = 10
        "mango" = 0
    }
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
    type = string
    default = "eu-west-1"
}

variable "project_tags" {
    type = map(string)
    default ={
        Component = "Frontend"
        Environment = "Production"
    }
}