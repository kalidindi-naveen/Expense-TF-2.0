variable "project_name" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "common_tags" {
  type = map(any)
  default = {
    Project     = "expense",
    Environment = "dev",
    Terraform   = "true"
  }
}

variable "cidr_block" {
  default = "100.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["100.0.1.0/24", "100.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["100.0.11.0/24", "100.0.12.0/24"]
}

variable "database_subnet_cidrs" {
  default = ["100.0.21.0/24", "100.0.22.0/24"]
}

variable "enable_peering" {
  default = false
}