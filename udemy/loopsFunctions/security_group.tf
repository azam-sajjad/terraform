resource "aws_security_group" "sg_example" {
    name = "example"
    dynamic "ingress" {
        for_each = [22, 443]
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
        }
    }
}


variable "ports" {
    type = map(list(string))
    default = {
        "22" = [ "127.0.0.1/32", "192.168.0.0/24" ]
        "443" = [ "0.0.0.0/0" ]
    }
}




resource "aws_security_group" "sg_example2" {
    name = "example2"
    dynamic "ingress" {
        for_each = var.ports
        content {
            from_port = ingress.key
            to_port = ingress.key
            cidr_blocks = ingress.value
            protocol = "tcp"
        }
    }
}