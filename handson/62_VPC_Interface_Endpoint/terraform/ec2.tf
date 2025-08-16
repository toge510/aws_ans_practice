resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet_for_demo_ec2_private_subnet.id
  vpc_security_group_ids  = [aws_security_group.sg_ec2_for_vpc_endpoint_demo.id]
  iam_instance_profile    = aws_iam_instance_profile.ec2_sqs_endpoint_demo.name
  key_name               = "homelab"
  tags = {
    Name = "ec2-vpc-endpoint-demo"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_iam_instance_profile" "ec2_sqs_endpoint_demo" {
  name = "ec2_sqs_endpoint_demo"
  role = aws_iam_role.ec2_role_for_sqs_endpoint_demo.name
}