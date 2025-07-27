# ╔══════════════════════════════════════════════════════════════════╗
# ║                  Tokyo Region (ap-northeast-1) Resources        ║
# ╚══════════════════════════════════════════════════════════════════╝

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ssm_parameter.al2023_ami.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.vpc_aws_private_subnet_1.id
  vpc_security_group_ids  = [aws_security_group.sg_ec2a.id]
  tags = {
    Name = "EC2A"
  }
}

# ╔══════════════════════════════════════════════════════════════════╗
# ║                  Virginia Region (us-east-1) Resources          ║
# ╚══════════════════════════════════════════════════════════════════╝

resource "aws_instance" "ec2_vpn" {
  provider              = aws.us_east_1
  ami                   = "ami-08a6efd148b1f7504"
  instance_type         = "t3.micro"
  subnet_id             = aws_subnet.vpc_dc_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.sg_ec2vpn.id]
  associate_public_ip_address = true
  key_name              = "homelab"
  tags = {
    Name = "EC2-VPN"
  }
}