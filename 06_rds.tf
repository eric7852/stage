resource "aws_db_instance" "seungjun_mydb" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  name                   = "mydb"
  identifier             = "mydb"
  username               = "admin"
  password               = "It12345!"
  parameter_group_name   = "default.mysql8.0"
  availability_zone      = "ap-northeast-2a"
  db_subnet_group_name   = aws_db_subnet_group.seungjun_dbsn.id
  vpc_security_group_ids = [aws_security_group.seungjun_websg.id]
  skip_final_snapshot    = true
  tags = {
    Name = "seungjun-mydb"
  }
}

resource "aws_db_subnet_group" "seungjun_dbsn" {
  name       = "seungjun-dbsb-group"
  subnet_ids = [aws_subnet.seungjun_pri[0].id, aws_subnet.seungjun_pri[1].id]
  tags = {
    Name = "seungjun-dbsb-group"
  }
}
