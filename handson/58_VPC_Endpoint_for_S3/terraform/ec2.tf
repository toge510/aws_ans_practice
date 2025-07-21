resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet_for_demo_ec2_private_subnet.id
  vpc_security_group_ids  = [aws_security_group.sg_ec2.id]
  iam_instance_profile    = aws_iam_instance_profile.ec2s3fullpermissionforendpointdemo.name
  tags = {
    Name = "ec2demo"
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

resource "aws_iam_instance_profile" "ec2s3fullpermissionforendpointdemo" {
  name = "ec2s3fullpermissionforendpointdemo"
  role = aws_iam_role.ec2s3fullpermissionforendpointdemo.name
}