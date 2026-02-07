variable "az1" {
  description = "1st Availability Zone"
    type        = string
}

variable "az2" {
  description = "2nd Availability Zone"
    type        = string
}

variable "vpc_cidr_addr" {
  description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "private_subnet_cidr_01" {
  description = "The CIDR block for the lambda first private subnet "
    type        = string
    default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_02" {
  description = "The CIDR block for the lambda second private subnet"
    type        = string
    default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_03" {
  description = "The CIDR block for the rds first private subnet "
    type        = string
    default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_04" {
  description = "The CIDR block for the rds second private subnet"
    type        = string
    default     = "10.0.4.0/24"
}
