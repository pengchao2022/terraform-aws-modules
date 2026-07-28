# define rds aurora cluster
resource "aws_rds_cluster" "this" {
  cluster_identifier       = var.name
  engine                   = var.engine
  engine_version           = var.engine_version
  database_name            = var.database_name

  # auth config
  master_username          = var.username
  master_password          = var.password

  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  apply_immediately                   = true

  # network and security group
  db_subnet_group_name     = var.db_subnet_group_name
  vpc_security_group_ids   = var.vpc_security_group_ids
  storage_encrypted        = true

  # backup and clear policy
  backup_retention_period   = 1
  skip_final_snapshot       = true
  final_snapshot_identifier = "${var.name}-final-snapshot"
  # maintenance window
  preferred_maintenance_window = "sun:03:00-sun:04:00"
  preferred_backup_window      = "01:00-02:00"
}

# define the compute node
resource "aws_rds_cluster_instance" "this" {
  count              = var.instance_count
  # requires unique
  identifier         = "${var.name}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id

  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  # valid value [0, 1, 5, 10, 15, 30, 60] 
  monitoring_interval = 0 
}