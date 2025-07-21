resource "aws_iam_role" "ec2s3fullpermissionforendpointdemo" {
  name = "ec2s3fullpermissionforendpointdemo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_full_access" {
  role       = aws_iam_role.ec2s3fullpermissionforendpointdemo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}