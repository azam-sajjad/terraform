#!/bin/bash
set -ex
AWS_REGION="us-east-1"
cd jenkins-packer
S3_BUCKET=$(aws s3 ls --region $AWS_REGION | grep jenkins-server-statefile | tail -n1 | cut -d ' ' -f3)
sed -i 's/jenkins-server-statefile/"${S3_BUCKET}"/' backend.tf
sed -i 's/#//g' backend.tf
aws s3 cp s3://${S3_BUCKET}/amivar.tf amivar.tf --region $AWS_REGION
terraform init
terraform apply -auto-approve -var APP_INTANCE_COUNT=1 -target aws_instance.app-instance

