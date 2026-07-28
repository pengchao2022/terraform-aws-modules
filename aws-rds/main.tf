resource "aws_db_instance" "this" {
  identifier        = var.identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  
  max_allocated_storage = var.max_allocated_storage

  username          = var.username
  password          = var.password
  multi_az          = true

  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  apply_immediately                   = true

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  # encryption in a prod env
  storage_encrypted = true
  
  backup_retention_period = var.backup_retention_period
  backup_window       = var.backup_window
  skip_final_snapshot = true
  publicly_accessible = false 

  tags                = var.tags

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

# use for_each
# var.replica_count = 3 then ["0", "1", "2"]

resource "aws_db_instance" "replica" {
  for_each = { for i in range(var.replica_count) : tostring(i) => i }

  replicate_source_db = aws_db_instance.this.arn
  identifier          = "${var.identifier}-replica-${each.key}"
  instance_class      = var.instance_class

  # read only replicas do not need username and password and storage
  skip_final_snapshot = true

  # should use the same vpc as the master db
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  depends_on = [
    aws_db_instance.this
  ]

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    create = "20m"
    delete = "20m"
  }
}