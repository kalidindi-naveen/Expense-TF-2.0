# Note CIDR's can only be
# 10.0.0.0 – 10.255.255.255, 	172.16.0.0 – 172.31.255.255, 	192.168.0.0 – 192.168.255.255
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

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "cidr_block" {
  default = "192.168.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["192.168.11.0/24", "192.168.12.0/24"]
}

variable "database_subnet_cidrs" {
  default = ["192.168.21.0/24", "192.168.22.0/24"]
}

variable "enable_peering" {
  default = false
}
