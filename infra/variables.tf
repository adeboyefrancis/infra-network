# Prefix tagging resources

variable "prefix" {
  description = "Prefix for resources in AWS"
  default     = "tch-conx"
}

variable "project" {
  description = "Project name for tagging resources"
  default     = "infra-connect"
}

variable "contact" {
  description = "Contact email for tagging resources"
  default     = "adeboye.francis@icloud.com"
}

variable "region" {
  description = "Primary resource region"
  default     = "eu-west-1"

}


variable "vpc_cidr" {
  description = "Main VPC CIDR Block"
  default     = "10.0.0.0/16"

}

variable "public_cidr_blocks" {
  description = "CIDR blocks for the subnets."
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
}


variable "private_cidr_blocks" {
  description = "CIDR blocks for the subnets."
  type        = list(string)
  default     = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}


variable "sandbox_ou_arn" {
  type        = string
  description = "Sandbox OU ARN"
}
