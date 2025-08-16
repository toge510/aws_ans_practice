resource "aws_security_group" "sg_ec2connectendpoint" {
  name        = "sgec2connectendpoint"
  description = "Allow SSH Outbound"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_subnet_for_demo_ec2_private_subnet.cidr_block]
  }
  tags = {
    Name = "sgec2connectendpoint"
  }
}

resource "aws_security_group" "sg_ec2_for_vpc_endpoint_demo" {
  name        = "ec2-for-vpc-endpoint-demo-sg"
  description = "Allow SSH inbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-for-vpc-endpoint-demo-sg"
  }
}

resource "aws_security_group" "sg_vpc_endpoint_demo" {
  name        = "vpc-endpoint-demo-sg"
  description = "Allow https outbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "vpc-endpoint-demo-sg"
  }
}