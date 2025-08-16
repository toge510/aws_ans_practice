# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Subnet
resource "aws_subnet" "private_subnet_for_demo_ec2_connect_endpoint_private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "demo_ec2_connect_endpoint_private_subnet"
  }
}

resource "aws_subnet" "private_subnet_for_demo_ec2_private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "demo_ec2_private_subnet"
  }
}

resource "aws_subnet" "private_subnet_for_demo_vpc_endpoint_private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "demo_vpc_endpoint_private_subnet"
  }
}

# Route Table
resource "aws_route_table" "demo_private_subnet_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "demo_private_subnet_route_table"
  }
}

# Route Table Association
resource "aws_route_table_association" "private_subnet_for_demo_ec2_connect_endpoint_private_subnet_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_for_demo_ec2_connect_endpoint_private_subnet.id
  route_table_id = aws_route_table.demo_private_subnet_route_table.id
}

resource "aws_route_table_association" "private_subnet_for_demo_ec2_private_subnet_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_for_demo_ec2_private_subnet.id
  route_table_id = aws_route_table.demo_private_subnet_route_table.id
}

resource "aws_route_table_association" "private_subnet_for_demo_vpc_endpoint_private_subnet_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_for_demo_vpc_endpoint_private_subnet.id
  route_table_id = aws_route_table.demo_private_subnet_route_table.id
}

# EC2 Instance Connect Endpoint
resource "aws_ec2_instance_connect_endpoint" "ec2_connect_endpoint" {
  subnet_id          = aws_subnet.private_subnet_for_demo_ec2_connect_endpoint_private_subnet.id
  security_group_ids = [aws_security_group.sg_ec2connectendpoint.id]
  tags = {
    Name = "ec2-connect-endpoint"
  }
}

# create vpc endpoint for sqs
resource "aws_vpc_endpoint" "sqs_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-1.sqs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_subnet_for_demo_vpc_endpoint_private_subnet.id]
  security_group_ids = [aws_security_group.sg_vpc_endpoint_demo.id]
  private_dns_enabled = true
  tags = {
    Name = "sqs-endpoint"
  }
}