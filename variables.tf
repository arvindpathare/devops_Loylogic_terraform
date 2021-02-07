#input variable definitions

variable "ami" {
  description = "ami id"
  type        = string
  default     = "ami-08e0ca9924195beba"
}

variable "instance_type" {
  description = "instance_type you want to deploy"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Availability zones for VPC"
  type        = string
  default     = "dev"
}

