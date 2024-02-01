## State Manipulation
use cases:
1) when upgrading between versions
2) when you ewant to rename a resource in terraform without recreating it
3) when you changed a key in a for_each, but you dont want to recreate the resources
4) change position of a resource in a list (resource[0], resource[1],...)
5) when you want to stop managing a resource, but you dont want to destroy the resource (terraform state rm)
6) when you want to show the attributes in the state of a resource (terraform state show)


resource "aws_ebs_volume" "example" {   <--------------OLD NAME>
resource "aws_ebs_volume" "example2" {
    availability_zone = "eu-west-1a"
    size = 8
    tags = {for k, v in merge({ Name = "Myvolume" }, var.project_tags): k => lower(v)}
}                      #<-------------------------input-------------->:  <---output--->


azams@eurusvm:~/dev/terraform/udemy/loopsFunctions$ terraform apply
aws_ebs_volume.example: Refreshing state... [id=vol-04ca887d6377ecd09]
aws_security_group.sg_example2: Refreshing state... [id=sg-0307f3534863b04c7]
aws_security_group.sg_example: Refreshing state... [id=sg-0e0025c45509ae872]

Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  + create
  ~ update in-place
  - destroy

Terraform will perform the following actions:

  # aws_ebs_volume.example will be destroyed
  # (because aws_ebs_volume.example is not in configuration)
  - resource "aws_ebs_volume" "example" {
      - arn                  = "arn:aws:ec2:eu-west-1:058264510430:volume/vol-04ca887d6377ecd09" -> null
      - availability_zone    = "eu-west-1a" -> null
      - encrypted            = false -> null
      - final_snapshot       = false -> null
      - id                   = "vol-04ca887d6377ecd09" -> null
      - iops                 = 100 -> null
      - multi_attach_enabled = false -> null
      - size                 = 8 -> null
      - tags                 = {
          - "Component"   = "frontend"
          - "Environment" = "production"
          - "Name"        = "myvolume"
        } -> null
      - tags_all             = {
          - "Component"   = "frontend"
          - "Environment" = "production"
          - "Name"        = "myvolume"
        } -> null
      - throughput           = 0 -> null
      - type                 = "gp2" -> null
    }

  # aws_ebs_volume.example2 will be created
  + resource "aws_ebs_volume" "example2" {
      + arn               = (known after apply)
      + availability_zone = "eu-west-1a"
      + encrypted         = (known after apply)
      + final_snapshot    = false
      + id                = (known after apply)
      + iops              = (known after apply)
      + kms_key_id        = (known after apply)
      + size              = 8
      + snapshot_id       = (known after apply)
      + tags              = {
          + "Component"   = "frontend"
          + "Environment" = "production"
          + "Name"        = "myvolume"
        }
      + tags_all          = {
          + "Component"   = "frontend"
          + "Environment" = "production"
          + "Name"        = "myvolume"
        }
      + throughput        = (known after apply)
      + type              = (known after apply)
    }


## SOLUTION - terraform state mv <RESOURCE>

azams@eurusvm:~/dev/terraform/udemy/loopsFunctions$ terraform state mv aws_ebs_volume.example aws_eb
s_volume.example2
Move "aws_ebs_volume.example" to "aws_ebs_volume.example2"
Successfully moved 1 object(s).


if you want to remove a resource from terraform project

use


## terraform state rm <RESOURCE>
> terraform state rm aws_ebs_volume.example2
azams@eurusvm:~/dev/terraform/udemy/loopsFunctions$ terraform state rm aws_ebs_volume.example2
Removed aws_ebs_volume.example2
Successfully removed 1 resource instance(s).
it will still exist on aws, but you wont manage it by terraform

if you change your mind : -

## terraform import <RESOURCE> <Name/ID>
azams@eurusvm:~/dev/terraform/udemy/loopsFunctions$ terraform import aws_ebs_volume.example2 vol-04ca887d6377ecd09
aws_ebs_volume.example2: Importing from ID "vol-04ca887d6377ecd09"...
aws_ebs_volume.example2: Import prepared!
  Prepared aws_ebs_volume for import
aws_ebs_volume.example2: Refreshing state... [id=vol-04ca887d6377ecd09]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.