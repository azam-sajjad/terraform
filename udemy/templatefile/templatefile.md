#***********************************************************************
# STEP 1
# first create a template file:
#!/bin/bash
echo "database-ip = ${myip}" >> /etc/myapp.config



#***********************************************************************
# STEP 2
# then create a templatefile resource that will read the template file and replace ${myip} with the IP address of an AWS instance created by Terraform
data "template_file" "my-template" {
    template = "${file("templates/init.tpl")}"
    vars {
        myip = "{aws_instance.database1.private_ip}"
    }
}



#***********************************************************************
# STEP 3
# then you can use the my-template resource when creating a new instance
# Creating a web server
resource "aws_instance" "web" {
    user_data = "${data.template_file.my-template.rendered}"
}

                            |Deprecated ^
                            |
                            | O R
                            |
                            |skip step 2 & 3 
                            | follow step 4 or 5



#***********************************************************************
# STEP 4
resource "aws_instance" "web" {
    user_data = templatefile("templates/init.tpl", {my_ip = aws_instance.database1.private_ip})
}


#***********************************************************************
# STEP 5
locals {
    web_vars = {
        my_ip = aws_instance.database1.private_ip
    }
}

resource "aws_instance" "web" {
    user_data = templatefile("templates/init.tpl", local.web_vars)
}

# when terraform runs, it will see that if first needs to spin up the database1 instance, 
# then generate the template, and only then spin up the web instance


# the web instance will have the template injected into the user_data
# and when it launches, the user_data will create a file /etc/myapp.config with the IP address of the database