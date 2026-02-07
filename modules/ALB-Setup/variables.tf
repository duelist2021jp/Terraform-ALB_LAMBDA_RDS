variable "private_subnet_id_01" {
    description = "The ID of the first private subnet"
    type        = string
}

variable "private_subnet_id_02"{
    description = "The ID of the second private subnet"
    type        = string
}

variable "alb_sg_id"{
    description = "Security Group ID for ALB"
    type = string
}

variable "lambda_arn"{
    description = "Lambda Function ARN"
    type = string
}

variable "lambda_function_name"{
    description = "Lambda Function Name"
    type = string
}