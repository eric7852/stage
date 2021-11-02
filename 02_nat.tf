resource "aws_eip" "lb_ip_a" {
  #  instance = aws_instance.web.id
  vpc = true
}

resource "aws_eip" "lb_ip_c" {
  #  instance = aws_instance.web.id
  vpc = true
}

resource "aws_nat_gateway" "seungjun_nga" {

  allocation_id = aws_eip.lb_ip_a.id
  subnet_id     = aws_subnet.seungjun_pub[0].id

  tags = {
    Name = "seungjun-nga-${var.avazone[0]}"
  }
}
#============nat gateway route table====================
resource "aws_route_table" "seungjun_ngart" {

  vpc_id = aws_vpc.seungjun_vpc.id
  route {
    cidr_block = var.cidr
    gateway_id = aws_nat_gateway.seungjun_nga.id
  }
  tags = {
    Name = "seungjun-nga-rt${var.avazone[0]}"
  }
}
#==========nat gateway route table association===============
resource "aws_route_table_association" "seungjun_ngartas" {
  count          = 2
  subnet_id      = aws_subnet.seungjun_pri[count.index].id
  route_table_id = aws_route_table.seungjun_ngart.id
}
