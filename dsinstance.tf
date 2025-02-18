resource "aws_db_instance" "db_instance" {
  allocated_storage         = 20
  engine                    = "postgres"
  engine_version            = "12"
  instance_class            = "db.t3.micro"
  name                      = "mydb"
  username                  = var.db_user
  password                  = var.db_pass
  multi_az                  = true
  backup_retention_period   = 7       # Required for automated backups (1-35)
  storage_type              = "standard"
  skip_final_snapshot       = true
  auto_minor_version_upgrade = true
}