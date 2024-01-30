Get downloads and update your modules
Get command will connect to the module's git repo, in case you are using public module

~~~sh
terraform get 



terraform show | grep -i "public_ip"
    associate_public_ip_address          = true
    public_ip                            = "44.202.7.40"
    map_public_ip_on_launch                        = false
    map_public_ip_on_launch                        = false


terraform graph
~~~
Graph will show connections between different resources

~~~sh
terraform import aws_instance.jenkins_server i-04c9aa1eeda22af89
~~~
this imports already created resource to be a part of project's state file