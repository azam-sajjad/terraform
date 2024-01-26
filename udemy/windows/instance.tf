# resource "aws_key_pair" "mykey" {
#     key_name = "vmaws"
#     public_key = "${file(var.PATH_TO_PUBLIC_KEY)}"
# }

resource "aws_instance" "windows_server" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t3.micro"
    key_name = "vmaws"
    vpc_security_group_ids = ["sg-05a4e6e2ffaf052fb"]
    user_data = <<EOF
<powershell>
net user ${var.INSTANCE_USERNAME} ${var.INSTANCE_PASSWORD} /add
net localgroup administrators ${var.INSTANCE_USERNAME} /add

winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
winrm  set winrm/config '@MaxTimeoutms="180000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow

net stop winrm
sc.exe config winrm start=auto
net start winrm
</powershell>
EOF

    provisioner "file" {
        source = "test.txt"
        destination = "C:/test.txt"
    }
    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/script.sh",
            "sudo /tmp/script.sh"
         ]
    }
    connection {
      type = "winrm"
      user = var.INSTANCE_USERNAME
      password = var.INSTANCE_PASSWORD
      host = "${self.public_ip}"
    }
    
}

output "public_ip" {
    value = aws_instance.windows_server.public_ip
}



