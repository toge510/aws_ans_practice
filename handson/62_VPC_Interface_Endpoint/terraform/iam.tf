resource "aws_iam_role" "ec2_role_for_sqs_endpoint_demo" {
  name = "ec2_role_for_sqs_endpoint_demo"
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

resource "aws_iam_role_policy_attachment" "attach_sqs_full_access" {
  role       = aws_iam_role.ec2_role_for_sqs_endpoint_demo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}