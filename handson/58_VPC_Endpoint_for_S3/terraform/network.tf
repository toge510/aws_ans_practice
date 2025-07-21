resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private_subnet_for_demo_ec2_connect_endpoint_private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs_for_demo_ec2_connect_endpoint_private_subnet
  availability_zone = var.availability_zone
  tags = {
    Name = "demo_ec2_connect_endpoint_private_subnet"
  }
}

resource "aws_subnet" "private_subnet_for_demo_ec2_private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs_for_demo_ec2_private_subnet
  availability_zone = var.availability_zone
  tags = {
    Name = "demo_ec2_private_subnet"
  }
}

resource "aws_route_table" "private_subnet_for_demo_ec2_private_subnet_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private_subnet_for_demo_ec2_private_subnet_route_table"
  }
}

resource "aws_route_table_association" "private_subnet_for_demo_ec2_private_subnet_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_for_demo_ec2_private_subnet.id
  route_table_id = aws_route_table.private_subnet_for_demo_ec2_private_subnet_route_table.id
}

resource "aws_ec2_instance_connect_endpoint" "ec2_connect_endpoint" {
  subnet_id          = aws_subnet.private_subnet_for_demo_ec2_connect_endpoint_private_subnet.id
  security_group_ids = [aws_security_group.sg_ec2connectendpoint.id]
  tags = {
    Name = "ec2-connect-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3_gateway_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_subnet_for_demo_ec2_private_subnet_route_table.id]
  tags = {
    Name = "s3-gateway-endpoint"
  }
}