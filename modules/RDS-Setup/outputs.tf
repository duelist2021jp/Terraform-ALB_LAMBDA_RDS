output "secret_ARN"{
    value = aws_secretsmanager_secret.db-secret.arn
}

output "secret_name"{
    value = aws_secretsmanager_secret.db-secret.name
}

output "dbname"{
    value = aws_db_instance.rds-instance.db_name
}

output "dbhost"{
    value = aws_db_instance.rds-instance.address
}

output "port"{
    value = aws_db_instance.rds-instance.port
}