# ╔══════════════════════════════════════════════════════════════════╗
# ║                  Tokyo Region (ap-northeast-1) Resources        ║
# ╚══════════════════════════════════════════════════════════════════╝

resource "aws_security_group" "sg_ec2a" {
  name        = "sgec2a"
  description = "Allow ICMP Inbound"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["192.168.0.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sgec2a"
  }
}

# ╔══════════════════════════════════════════════════════════════════╗
# ║                  Virginia Region (us-east-1) Resources          ║
# ╚══════════════════════════════════════════════════════════════════╝

resource "aws_security_group" "sg_ec2vpn" {
  provider    = aws.us_east_1
  name        = "sg_ec2vpn"
  description = "Allow all inbound"
  vpc_id      = aws_vpc.vpc_dc.id
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.10.0.0/24"]
  }
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
    Name = "sgec2vpn"
  }
}
