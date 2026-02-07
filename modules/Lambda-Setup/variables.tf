variable "secret_ARN"{
    description = "ARN for Secret"
    type = string
}

variable "secret_Name"{
    description = "Secret Name"
    type = string
}

variable "private_subnet_id_01" {
    description = "The ID of the first private subnet"
    type        = string
}

variable "private_subnet_id_02"{
    description = "The ID of the second private subnet"
    type        = string
}

variable "lambda_sg_id"{
    description = "Security Group ID for Lambda"
    type = string
}

variable "dbname"{
    description = "RDS Database Name"
    type = string
}

variable "dbhost"{
    description = "RDS Endpoint DNS"
    type = string
}

variable "port_number"{
    description = "RDS Connection Port"
    type = string
}