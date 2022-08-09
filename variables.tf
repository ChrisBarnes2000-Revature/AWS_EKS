variable "aws_access_key" {
  description = "AWS access key"
  default     = "<REPLACE_WTIH_YOUR_ACCESS_KEY>"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  default     = "<REPLACE_WTIH_YOUR_ACCESS_KEY>"
  type        = string
}

variable "public_key" {
  description = "Your public key."
  default     = "<REPLACE_WTIH_YOUR_PUBLIC_KEY>"
  type        = string
}

variable "my_home_ip" {
  description = "Your home ip. For firewall rules that allow you access to cluster"
  default     = "<REPLACE_WTIH_YOUR_HOME_IP>"
  type        = string
}

#
#
#

variable "profile" {
  description = "The aws profile. https://docs.aws.amazon.com/customerprofiles/latest/APIReference/API_Profile.html"
  default     = "default"
  type        = string
}

variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  default     = "us-west-1"
  type        = string
}

variable "user_name" {
  description = "The aws user name"
  default     = "<REPLACE_WTIH_YOUR_USERNAME>"
  type        = string
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  default     = "<REPLACE_WTIH_YOUR_PROJECT_NAME>"
  type        = string
}

#
#
#

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "P3-Ecommerce"
    "Environment" = "Development"
    "Owner"       = "Mehrab's 2206 DevOPs Batch"
  }
}

#
#
#

variable "max_size" {
  description = ""
  type        = number
  default     = 3
}

variable "min_size" {
  description = ""
  type        = number
  default     = 1
}

variable "desired_size" {
  description = ""
  type        = number
  default     = 2
}

variable "instance_type" {
  description = ""
  type        = list(string)
  default     = ["t3.medium"]
}

variable "ami_id" {
  description = ""
  type        = string
  default     = "ami-052efd3df9dad4825" # ubuntu 22.04 LTS server optimized for eks.
}

#
#
#

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "private_subnets_count" {
  description = ""
  type        = number
  default     = 2
}

variable "public_subnets_count" {
  description = ""
  type        = number
  default     = 2
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "eks_vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  default     = "10.0.0.0/16"
  type        = string
}

variable "ec2_vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  default     = "10.0.0.0/16"
  type        = string
}

variable "availability_zones" {
  description = ""
  type        = list(string)
  default     = ["us-west-1a", "us-west-1b", "us-west-1c", "us-west-1d", "us-west-1e"]
}

variable "azs" {
  description = ""
  type        = list(string)
  default     = slice(data.aws_availability_zones.available.names, 0, 2)
}
