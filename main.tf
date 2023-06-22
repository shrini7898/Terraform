## creating aws s3 bucket with the name of "shrini-s3"

resource "aws_s3_bucket" "s3" {
    bucket = "shrini-s3"
    acl = "private"
}

## creating aws_dyanmodb_table with the name of "terraform-state-lock-dynamo"

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

## moving the state file from "local" to "shrini-s3" bucket

terraform {
  backend "s3" {
    bucket = "shrini-s3"
    dynamodb_table = "terraform-state-lock-dynamo"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

## creating VPC and if we want to give vpc to name we have to mention on tags like below
resource "aws_vpc" "shrini_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
  Name = var.vpc_name
  }
}
output "shrini_vpc" {
  value = aws_vpc.shrini_vpc.id
}

## Creating Internet gateway
resource "aws_internet_gateway" "shrini-IGW" {
  vpc_id = aws_vpc.shrini_vpc.id
  tags = {
    Name = var.aws_internet_gateway_name
  }
}
output "shrini-IGW" {
  value = aws_internet_gateway.shrini-IGW.id
}

## creating route table and exposing to internet with the help of CIDR block
resource "aws_route_table" "shrini_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shrini-IGW.id
  }
  tags = {
    Name = var.aws_route_table_Name
  }
}
output "shrini_route_table" {
  value = aws_route_table.shrini_route_table.id
}
## Creating Subnet with the above mentioned VPC
resource "aws_subnet" "shrini_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}
output "shrini_subnet" {
  value = aws_subnet.shrini_subnet.id
}
## Associating subnet with Route Table
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = var.subnet_id
  route_table_id = var.route_table_id
}
output "subnet_association" {
  value = aws_route_table_association.subnet_association.subnet_id
}
## Creating Security Group to allow port 22.80,443 ingress = inbound egress =outbound
resource "aws_security_group" "my_security_group" {
  name        = var.security_group_name
  description = "Allow SSH, HTTP, and HTTPS traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
  
output "my_security_group" {
    value = aws_security_group.my_security_group.id
}
##Creating Ubuntu server and install/enable apache2
resource "aws_instance" "ubuntu_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  security_groups       = [aws_security_group.my_security_group.id]
  # User data script to install and enable Apache
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install apache2 -y
    sudo systemctl enable apache2
    sudo systemctl start apache2
  EOF
}
output "ubuntu_server" {
    value = aws_instance.ubuntu_server.public_ip
}