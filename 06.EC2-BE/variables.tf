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
    Terraform   = "true",
    Component   = "backend"
  }
}

variable "zone_name" {
  default = "step-into-iot.cloud"
}