resource "aws_s3_bucket" "vpc_endpoint_demo" {
  bucket = "aws-vpc-endpoint-demo-202507212200"
  tags = {
    Name = "aws-vpc-endpoint-demo"
  }
}