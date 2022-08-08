variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "profile" {
  description = "The aws profile. https://docs.aws.amazon.com/customerprofiles/latest/APIReference/API_Profile.html"
  type        = string
  default     = "default"
}

variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "us-west-1"
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  # description = "Name of the project deployment."
  type = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "P3-Ecommerce"
    "Environment" = "Development"
    "Owner"       = "Mehrab's 2206 DevOPs Batch"
  }
}

variable "my_home_ip" {
  description = "Your home ip. For firewall rules that allow you access to cluster"
  type        = string
  # default     = "000.000.000.000/32" # CHANGE ME THEN UNCOMMENT ME!
}
variable "user_name" {
  description = "The aws user name"
  type        = string
  # default     = "bob" # CHANGE ME THEN UNCOMMENT ME!
}
