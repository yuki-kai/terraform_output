# --------------------------------------------------
# VPC
# --------------------------------------------------
resource "aws_vpc" "vpc_output" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tag-output"
  }
}

# --------------------------------------------------
# インターネットゲートウェイ
# --------------------------------------------------
resource "aws_internet_gateway" "internet_gateway_output" {
  vpc_id = aws_vpc.vpc_output.id

  tags = {
    Name = "tag-output"
  }
}

# --------------------------------------------------
# ルートテーブル
# --------------------------------------------------
resource "aws_route_table" "route_table_output" {
  vpc_id = aws_vpc.vpc_output.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_output.id
  }

  tags = {
    Name = "tag-output"
  }
}

# --------------------------------------------------
# サブネット
# --------------------------------------------------
resource "aws_subnet" "subnet_public_1a_output" {
  vpc_id                  = aws_vpc.vpc_output.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tag-output"
  }
}
resource "aws_subnet" "subnet_public_1c_output" {
  vpc_id                  = aws_vpc.vpc_output.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "tag-output"
  }
}

# --------------------------------------------------
# ルートテーブルとサブネットの関連付け
# --------------------------------------------------
resource "aws_route_table_association" "route_table_association_a_output" {
  subnet_id      = aws_subnet.subnet_public_1a_output.id
  route_table_id = aws_route_table.route_table_output.id
}
resource "aws_route_table_association" "route_table_association_c_output" {
  subnet_id      = aws_subnet.subnet_public_1c_output.id
  route_table_id = aws_route_table.route_table_output.id
}
