variable "aws_region" {
  default = "eu-north-1"
}

variable "key_name" {
  description = "SSH Key pair name"
  type = string 
}

variable "frontend_bucket" {
  default = "raghad-frontend-bucket"
}

variable "media_bucket" {
  default = "raghad-media-bucket"
}