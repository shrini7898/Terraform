## -------> VPC
## giving vpc configuration-details (like name,cidr,tags etc) 
variable "vpc_name" {
  default     = "shrini-terraform-vpc"
}
## with the help of cidr we can create our vpc
variable "vpc_cidr" {
  default     = "186.187.0.0/24"
}
## -------> IGW
## giving name to IGW 
variable "aws_internet_gateway_name" {
    default = "shrini-IGW"
}
## --------> RT
## giving name to route table
variable "aws_route_table_Name" {
    default = "shrini-RT"
}
## giving cidr_block to route with zero to get access via internet
variable "aws_route_table_cidr_block" {
  default = "0.0.0.0/0"
}
## -------> SUBNET
## giving subnet a name
variable "subnet_name" {
  default = "shrini-sub-01"
}
## giving CIDR block to subnet 
variable "subnet_cidr_block" {
    default = "186.187.0.0/28"
}
variable "vpc_id" {
    default = "vpc-02606eea761d72b82"
}
## -------> SUBNET WITH RT
## selecting subnet-id 
variable "subnet_id" {
    default = "subnet-007e2e2558dbbf542"
}
## selecting rt for subnet
variable "route_table_id" {
    default = "rtb-0a3ea1378c05bafa0"
}
## creating security group for the above vpc 
variable "security_group_name" {
  default = "my-security-group"
}
## creating INSTANCES
variable "ami_id" {
    default = "ami-08e5424edfe926b43"
}
variable "instance_type" {
    default = "t2.micro"
}  
variable "my_security_group_id" {
    default = "sg-04cdb9c70b311406d"
}
variable "instance_name" {
  default = "ubuntu_server"
}
variable "aws_internet_gateway_id" {
  default = "igw-093fbf027933c3fea"
}