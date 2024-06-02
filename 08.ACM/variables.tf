variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Environment = "dev"
    Terraform   = "true"
    Component   = "app-alb"
  }
}

variable "zone_name" {
  default = "step-into-iot.cloud"
}

variable "zone_id" {
  default = "Z00115131QTKDUSV158EL"
}