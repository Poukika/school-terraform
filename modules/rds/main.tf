resource "aws_db_subnet_group" "db" {
  name       = "main"
  subnet_ids = [var.subnets_ids[1], var.subnets_ids[2]]

  tags = {
    Name = "sg-db"
  }
}

resource "aws_db_instance" "mysql" {
  availability_zone       = var.availability_zone_a
  allocated_storage       = 10
  db_name                 = var.db_name
  engine                  = "mysql"
  engine_version          = "8.0.33"
  instance_class          = var.db_type_instance
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.db.name
  vpc_security_group_ids  = [var.sg_db]
  storage_encrypted       = false
  storage_type            = "gp2"
  backup_retention_period = 1
}

resource "aws_db_instance" "replica_mysql" {
  instance_class      = var.db_type_instance
  skip_final_snapshot = true
  replicate_source_db = aws_db_instance.mysql.identifier
  availability_zone   = var.availability_zone_b
  depends_on          = [aws_db_instance.mysql]
}