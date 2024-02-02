provider "cloudinit" {}


data "cloudinit_config" "cloudinit_jenkins" {
    gzip = false
    base64_encode = false

    part {
        content_type = "text/x-shellscript"
        content = templatefile("scripts/install.sh", {
            DEVICE = var.INSTANCE_DEVICE_NAME
            JENKINS_VERSION = var.JENKINS_VERSION
            TERRAFORM_VERSION = var.TERRAFORM_VERSION
        })
    }
}