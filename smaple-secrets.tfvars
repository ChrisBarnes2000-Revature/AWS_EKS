aws_access_key = "<REPLACE_WTIH_YOUR_ACCESS_KEY>"
aws_secret_key = "<REPLACE_WTIH_YOUR_SECRET_KEY>"
public_key     = "Jenkins-us-west-1-cali"
my_home_ip     = "000.000.000.000/32"

profile   = "default"
region    = "us-west-1"
user_name = "<REPLACE_WTIH_YOUR_USERNAME>"
project   = "P3-E-Commerece"


tags = {
  project     = "P3-E-Commerece"
  Environment = "Development"
  Owner       = "Mehrab's 2206 DevOPs Batch"
}

availability_zones_count = 2
private_subnets_count    = 2
public_subnets_count     = 2
subnet_cidr_bits         = 8
vpc_cidr                 = ["10.0.0.0/16", "172.0.0.0/16"]
availability_zones       = ["us-west-1a", "us-west-1b", "us-west-1c", "us-west-1d", "us-west-1e"]
# azs  = slice(data.aws_availability_zones.available.names, 0, 2)
