# ╔══════════════════════════════════════════════════════════════════╗
# ║                  Tokyo Region (ap-northeast-1) Resources        ║
# ╚══════════════════════════════════════════════════════════════════╝

resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-AWS"
  }
}

resource "aws_subnet" "vpc_aws_private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "VPC-AWS-Private-1"
  }
}

resource "aws_route_table" "vpc_aws_private_subnet_1_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "VPC-AWS-Private-RT"
  }
}

resource "aws_route_table_association" "vpc_aws_private_subnet_1_route_table_association" {
  subnet_id      = aws_subnet.vpc_aws_private_subnet_1.id
  route_table_id = aws_route_table.vpc_aws_private_subnet_1_route_table.id
}

resource "aws_route" "vpc_aws_private_subnet_1_route_to_vgw" {
  route_table_id         = aws_route_table.vpc_aws_private_subnet_1_route_table.id
  destination_cidr_block = "192.168.0.0/24"
  gateway_id             = aws_vpn_gateway.vpc_aws_vpn_gateway.id
}

resource "aws_vpn_gateway" "vpc_aws_vpn_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "VPC-AWS-VGW"
  }
}

resource "aws_customer_gateway" "dc_cgw" {
  bgp_asn    = 65000
  ip_address = aws_instance.ec2_vpn.public_ip
  type      = "ipsec.1"
  tags = { 
    Name = "DC-CGW"
  }
}

resource "aws_vpn_connection" "dc_vpn_connection" {
  vpn_gateway_id      = aws_vpn_gateway.vpc_aws_vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.dc_cgw.id
  type                = "ipsec.1"
  static_routes_only  = true
  local_ipv4_network_cidr = "192.168.0.0/24"
  remote_ipv4_network_cidr = "10.10.0.0/24"
  tags = {
    Name = "DC-VPN-Connection"
  }
}

resource "aws_vpn_connection_route" "dc_vpn_connection_route" {
  vpn_connection_id = aws_vpn_connection.dc_vpn_connection.id
  destination_cidr_block = "192.168.0.0/24"
}

# ╔══════════════════════════════════════════════════════════════════╗
# ║                  Virginia Region (us-east-1) Resources          ║
# ╚══════════════════════════════════════════════════════════════════╝

resource "aws_vpc" "vpc_dc" {
  provider              = aws.us_east_1
  cidr_block            = "192.168.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags = {
    Name = "VPC-DC"
  }
}

resource "aws_internet_gateway" "vpc_dc_igw" {
  provider = aws.us_east_1
  vpc_id   = aws_vpc.vpc_dc.id
  tags = {
    Name = "VPC-DC-IGW"
  }
}

resource "aws_subnet" "vpc_dc_public_subnet_1" {
  provider = aws.us_east_1
  vpc_id            = aws_vpc.vpc_dc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "VPC-DC-Public-1"
  }
}

resource "aws_route_table" "vpc_dc_public_subnet_1_route_table" {
  provider = aws.us_east_1
  vpc_id = aws_vpc.vpc_dc.id
  tags = {
    Name = "VPC-DC-Public-RT"
  }
}

resource "aws_route_table_association" "vpc_dc_public_subnet_1_route_table_association" {
  provider = aws.us_east_1
  subnet_id      = aws_subnet.vpc_dc_public_subnet_1.id
  route_table_id = aws_route_table.vpc_dc_public_subnet_1_route_table.id
}

resource "aws_route" "vpc_dc_public_subnet_1_route_to_igw" {
  provider = aws.us_east_1
  route_table_id         = aws_route_table.vpc_dc_public_subnet_1_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_dc_igw.id
}
