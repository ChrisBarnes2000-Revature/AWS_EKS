terraform {
  # backend "remote" {
  #   organization = "Batch22"
  #   workspaces {
  #     name = "Batch_Terraform_Workspace"
  #   }
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.23.0"
    }
  }
}

provider "aws" {}

# 1. Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "production-vpc"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-gateway"
  }
}

# 3. Create Route Table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0" #allow all
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example-route-table"
  }
}

# 4. Create Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet"
  }
}

# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.example.id
}

# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "sg" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["24.245.76.148/32"]
    ipv6_cidr_blocks = ["24.245.76.148/32"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["24.245.76.148/32"]
    ipv6_cidr_blocks = ["24.245.76.148/32"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["24.245.76.148/32"]
    ipv6_cidr_blocks = ["24.245.76.148/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "one" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.sg.id]

  # this can be done in the instance.
  # attachment {
  #   instance     = aws_instance.ubuntu_server.id
  #   device_index = 1
  # }
}

# 8. Assign an elastic IP ot the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.one.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.gw
  ]
}

# 9. Create Ubuntu server and install/enable nginx
resource "aws_instance" "ubuntu_server" {
  ami               = "ami-08d4ac5b634553e16"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  # key_name          = "EC2_Key"
  key_name = aws_key_pair.ubuntu-key.key_name

  network_interface {
    network_interface_id = aws_network_interface.one.id
    device_index         = 0
  }

  user_data = file("install_nginx.sh")

  tags = {
    Name = var.instance_name
  }
}

# 10. ssh key pair
resource "aws_key_pair" "ubuntu-key" {
  key_name   = "ubuntu-key"
  public_key = file(".ssh/id_rsa.pub")
}
