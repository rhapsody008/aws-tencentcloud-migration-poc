# Trust policy for the IAM role
data "aws_iam_policy_document" "zy_test_role_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "zy_test_ec2_role" {
  name               = "read_only_rds_ssm_cloudwatch_role"
  assume_role_policy = data.aws_iam_policy_document.zy_test_role_trust_policy.json
}

# IAM Policy for read-only access to RDS, SSM, and CloudWatch
resource "aws_iam_policy" "read_only_policy" {
  name        = "ReadOnlyRDS_SSM_CloudWatch"
  description = "Provides read-only access to RDS, SSM, and CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:Describe*",
          "ssm:Get*",
          "ssm:List*",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "read_only_policy_attachment" {
  role       = aws_iam_role.zy_test_ec2_role.name
  policy_arn = aws_iam_policy.read_only_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "zy_test_instance_profile" {
  name_prefix = var.aws_resource_prefix
  role        = aws_iam_role.zy_test_ec2_role.name
}
