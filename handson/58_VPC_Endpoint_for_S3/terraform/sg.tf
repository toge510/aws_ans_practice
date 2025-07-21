resource "aws_security_group" "sg_ec2connectendpoint" {
  name        = "sgec2connectendpoint"
  description = "Allow SSH Outbound"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidrs_for_demo_ec2_private_subnet]
  }
  tags = {
    Name = "sgec2connectendpoint"
  }
}

resource "aws_security_group" "sg_ec2" {
  name        = "sgec2"
  description = "Allow SSH inbound and https outbound" 
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
    prefix_list_ids = ["pl-61a54008"]
  }
  tags = {
    Name = "sgec2"
  }
}

