# resource "aws_iam_role" "s3_mybucket_role" {
#     name = "s3-statefile-bucket-role"
#     assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = {
#     tag-key = "tag-value"
#   }
# }

data "aws_iam_role" "s3_mybucket_role" {
  name = "s3-statefile-bucket-role"
}
data "aws_iam_instance_profile" "s3-mybucket-role-instanceprofile" {
    name = "s3-statefile-bucket-role"
}
# resource "aws_iam_instance_profile" "s3-mybucket-role-instanceprofile" {
#     name = "s3-statefile-bucket-role"
#     role = data.aws_iam_role.s3_mybucket_role.name
# }

resource "aws_iam_role_policy" "s3-mybucket-role-policy" {
    name = "s3-mybucket-role-policy"
    role = "${data.aws_iam_role.s3_mybucket_role.id}"
     policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = [
                    "arn:aws:s3:::jenkins-server-statefile",
                    "arn:aws:s3:::jenkins-server-statefile/*"
                ]

            }
        ]
    }
)
}

output "instance_profile_name" {
    value = data.aws_iam_instance_profile.s3-mybucket-role-instanceprofile.name
}