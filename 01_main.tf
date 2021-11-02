
#=====================provider=======================
provider "aws" {
  region = "ap-northeast-2"
}


#========================key pair====================================
resource "aws_key_pair" "seungjun_key" {
  key_name   = "tf-key1"
  public_key = file("../../../.ssh/id_rsa.pub")
}

#=========================vpc======================================
resource "aws_vpc" "seungjun_vpc" {
  cidr_block           = var.cidr_main
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "seungjun-vpc"
  }
}

#========================subnet====================================
resource "aws_subnet" "seungjun_pub" {
  count             = 2
  vpc_id            = aws_vpc.seungjun_vpc.id
  cidr_block        = var.public_s[count.index]
  availability_zone = "${var.region}${var.avazone[count.index]}"
  tags = {
    name = "${var.name}-pub${var.avazone[count.index]}"
  }
}

resource "aws_subnet" "seungjun_pri" {
  count             = 2
  vpc_id            = aws_vpc.seungjun_vpc.id
  cidr_block        = var.private_s[count.index]
  availability_zone = "${var.region}${var.avazone[count.index]}"
  tags = {
    name = "${var.name}-pri${var.avazone[count.index]}"
  }
}


resource "aws_subnet" "seungjun_db" {
  count             = 2
  vpc_id            = aws_vpc.seungjun_vpc.id
  cidr_block        = var.db_s[count.index]
  availability_zone = "${var.region}${var.avazone[count.index]}"
  tags = {
    name = "${var.name}-db${var.avazone[count.index]}"
  }
}
#===================internet gateway=====================
resource "aws_internet_gateway" "seungjun_ig" {
  vpc_id = aws_vpc.seungjun_vpc.id

  tags = {
    Name = "seungjun-ig"
  }
}
#=================routing table===========================
resource "aws_route_table" "seungjun_rt" {
  vpc_id = aws_vpc.seungjun_vpc.id

  route {
    cidr_block = var.cidr
    gateway_id = aws_internet_gateway.seungjun_ig.id
  }
  tags = {
    Name = "seungjun-rt"
  }
}
#================routing table association================
resource "aws_route_table_association" "seungjun_rtas" {
  count          = 2
  subnet_id      = aws_subnet.seungjun_pub[count.index].id
  route_table_id = aws_route_table.seungjun_rt.id
}
