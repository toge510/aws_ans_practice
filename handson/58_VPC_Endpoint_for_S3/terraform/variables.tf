variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "availability_zone" {
  description = "Availability zones in Tokyo region"
  type        = string
  default     = "ap-northeast-1a"
}

variable "private_subnet_cidrs_for_demo_ec2_connect_endpoint_private_subnet" {
  description = "CIDR blocks for the private subnets"
  type        = string
  default     = "10.10.0.0/24"
}

variable "private_subnet_cidrs_for_demo_ec2_private_subnet" {
  description = "CIDR blocks for the private subnets"
  type        = string
  default     = "10.10.1.0/24"
}