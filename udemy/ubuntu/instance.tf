resource "aws_key_pair" "mykey" {
    key_name = "vmaws"
    public_key = "${file(var.PATH_TO_PUBLIC_KEY)}"
}

resource "aws_instance" "tfserver" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t3.micro"
    key_name = "${aws_key_pair.mykey.key_name}"
    vpc_security_group_ids = ["sg-05a4e6e2ffaf052fb"]
    provisioner "file" {
        source = "script.sh"
        destination = "/tmp/script.sh"
    }
    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/script.sh",
            "sudo /tmp/script.sh"
         ]
    }
    connection {
      user = var.INSTANCE_USERNAME
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
      host = "${self.public_ip}"
    }
    
}

output "public_ip" {
    value = aws_instance.tfserver.public_ip
}



