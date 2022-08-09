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

min_size      = 1
max_size      = 3
desired_size  = 1
instance_type = ["t3.medium"]
ami_id        = "ami-052efd3df9dad4825" # ubuntu 22.04 LTS server optimized for eks.

availability_zones_count = 2
private_subnets_count    = 2
public_subnets_count     = 2
subnet_cidr_bits         = 8
eks_vpc_cidr             = ["10.0.0.0/16", "172.0.0.0/16"]
ec2_vpc_cidr             = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20", "143.55.64.0/20"] # github webhooks ip's. Add your ip as well
availability_zones       = ["us-west-1a", "us-west-1b", "us-west-1c", "us-west-1d", "us-west-1e"]
azs                      = slice(data.aws_availability_zones.available.names, 0, 2)
