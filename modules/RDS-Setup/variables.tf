variable "az1" {
  description = "The first availability zone"
  type        = string
}

variable "az2" {
  description = "The second availability zone"
  type        = string
}

variable "private_subnet_id_03"{
  description = "The ID of the rds first private subnet"
  type        = string
}

variable "private_subnet_id_04"{
  description = "The ID of the rds second private subnet"
  type        = string
}

variable "rds_sg_id" {
  description = "The security group ID for the RDS instance"
  type        = string 
}




