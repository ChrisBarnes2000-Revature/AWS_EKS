variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "my_home_ip" {
  description = "Your home ip. For firewall rules that allow you access to cluster"
  type        = string
  default     = "24.245.76.148/32" # CHANGE ME!
}
variable "user_name" {
  description = "The aws user name"
  type        = string
  default     = "bryon" # CHANGE ME!
}
