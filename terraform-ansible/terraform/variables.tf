variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t3.small"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS - ap-south-1"
  default     = "ami-0f58b397bc5c1f2e8"
}

variable "key_name" {
  description = "Your existing EC2 key pair name"
  default     = "sowjanya-cicd"
}
