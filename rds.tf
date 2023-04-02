resource "aws_db_instance" "rds" {
  allocated_storage = var.allocated_storage
  engine_version    = var.engine_version
  db_subnet_group_name = aws_db_subnet_group.default.id
  multi_az          = false
  db_name           = var.db_name
  username          = var.rds_db_admin
  password          = var.rds_db_password
  instance_class    = var.instance_class
  engine            = var.db_engine
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "default"{
  name = "main"
  subnet_ids = [
    for i in range(0,2): aws_subnet.database_subnet[i].id
  ]
  tags = {
    Name = "My DB subnet group"
  }
}
