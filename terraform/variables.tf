# variable "aws_access_key_id" {
#   type        = string
#   description = "AWS Access Key"
# }

# variable "aws_secret_key_id" {
#   type        = string
#   description = "AWS Secret Key"
# }

# variable "aws_key_pair_name" {
#   type        = string
#   description = "AWS Key Pair Name"
# }

# variable "aws_key_pair_file" {
#   type = string
#   description = "AWS Key Pair File"
# }

variable "aws_default_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_cloudwatch_retention_in_days" {
  type        = number
  description = "AWS CloudWatch Logs Retention in Days"
  default     = 1
}

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "app_version" {
  type        = string
  description = "Application Version"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}

variable "ecr_repository" {
  description = "ECR repository name"
}
