# SecruitManager Key for RDS Conection
resource "aws_secretsmanager_secret" "rds" {
  name = "secrect-rds"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = "${var.db_user}:${var.db_password}@tcp(${module.cluster.cluster_endpoint})/dev?checkConnLiveness=false&maxAllowedPacket=0&timeout=5s"
}

