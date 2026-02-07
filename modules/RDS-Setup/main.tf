data "aws_ssm_parameter" "my-kmskey-id"{
  name = "MyKMSKeyID"
}

ephemeral "aws_secretsmanager_random_password" "random_dbpassword"{
  password_length = 16
  exclude_characters = "/@\" '`\\"
}

resource "aws_secretsmanager_secret" "db-secret"{
  name        = "db-secret"
  kms_key_id  = data.aws_ssm_parameter.my-kmskey-id.value
  recovery_window_in_days = 0

  depends_on = [ data.aws_ssm_parameter.my-kmskey-id ]
}

# Create RDS DB SubnetGroup
resource "aws_db_subnet_group" "rds-subnet-grp"{
  name        = "rds-subnet-group"
  subnet_ids  = [var.private_subnet_id_03,var.private_subnet_id_04]

  tags={
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "rds-instance"{
  allocated_storage             = 20
  storage_type                  = "gp2"
  engine                        = "postgres"
  engine_version                = "16.6"
  instance_class                = "db.t3.small"
  db_name                       = "db01"
  identifier                    = "rds-pgsql"
  username                      = "postgres"
  password_wo                   = ephemeral.aws_secretsmanager_random_password.random_dbpassword.random_password
  password_wo_version           = 1
  network_type                  = "IPV4"
  publicly_accessible           = "false"
  multi_az                      = true

  db_subnet_group_name          = aws_db_subnet_group.rds-subnet-grp.name
  vpc_security_group_ids        = [var.rds_sg_id]

  skip_final_snapshot           = true
  tags = {
    Name = "rds-instance"
  }

  depends_on = [aws_db_subnet_group.rds-subnet-grp]
}

resource "aws_secretsmanager_secret_version" "db-secret-version"{
  secret_id                 = aws_secretsmanager_secret.db-secret.id
  #jsonencode var to store password in json format
  secret_string_wo          = jsonencode({
    username = "postgres",
    password = ephemeral.aws_secretsmanager_random_password.random_dbpassword.random_password,
  })
  secret_string_wo_version  = 1

  depends_on = [ aws_db_instance.rds-instance ]
}



