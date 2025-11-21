variable "region-name" {
    description = "Region name"
  
}

variable "vpc-cidr-block" {
    description = "CIDR block for the vpc"
    
}

variable "vpc-name" {
    description = "Name for the vpc"
  
}

variable "igw-name" {
    description = "Internet gateway name"
  
}

variable "nat-gw-name" {
    description = "Name for the nat gateway"
}

variable "web-subnet1-cidr" {
    description = "CIDR block for the first web subnet"
  
}

variable "web-subnet1-name" {
    description = "Name for the web tier subnet 1"

}

variable "web-subnet2-name" {
    description = "Name for the web tier subnet 2"
  
}

variable "web-subnet2-cidr" {
    description = "CIDR block for the second web tier subnet"
  
}

variable "app-subnet1-name" {
    description = "Name of the first private subnet for app tier"
  
}

variable "app-subnet1-cidr" {
    description = "CIDR block of the first app subnet"
  
}

variable "app-subnet2-cidr" {
    description = "CIDR block for the second app subnet"
  
}

variable "app-subnet2-name" {
    description = "Name of the second app subnet "
  
}

variable "db-subnet1-name" {
    description = "Name of the first db subnet"
  
}

variable "db-subnet1-cidr" {
    description = "CIDR block for the first db subnet"
  
}

variable "db-subnet2-cidr" {
    description = "CIDR block for the second db subnet"
  
}

variable "db-subnet2-name" {
    description = "Name of the second db subnet"
  
}

variable "az-1" {
    description = "Availability zone 1"
  
}

variable "az-2" {
    description = "Availability zone 2"
  
}
variable "public-rt-name" {
    description = "Name of the public route table"
  
}

variable "private-rt-name" {
    description = "Name of the private route table"
  
}

variable "launch-template-web-name" {
    description = "Name of the web tier launch template"
}

variable "image-id" {
    description = "Value for the image-id"
}

variable "instance-type" {
    description = "value for the instance type"
  
}
variable "key-name" {
    description = "value for the key name"
  
}

variable "web-instance-name" {
    description = "value for web instances"
  
}

variable "alb-web-name" {
    description = "Name of the load balancer for the web tier instances"
  
}

variable "alb-sg-web-name" {
    description = "Name of the security group of the alb web tier"
  
}

variable "asg-web-name" {
    description = "Name of the auto scaling group for the web tier"
  
}

variable "asg-sg-web-name" {
    description = "Name of the sec group for the asg web tier"
  
}

variable "tg-web-name" {
    description = "Name for the target group name"
  
}

variable "launch-template-app-name" {
    description = "name of the launch template app tier"
}

variable "app-instance-name" {
    description = "value for app instances"
  
}

variable "alb-app-name" {
    description = "Name of the alb for the app tier"
}

variable "alb-sg-app-name" {
    description = "Name of the sec group for the alb app tier"
  
}

variable "asg-app-name" {
    description = "Name of the autoscaling group for the app tier"
  
}

variable "asg-sg-app-name" {
    description = "Name of the sec group for the auto scaling for app tier"
  
}

variable "tg-app-name" {
    description = "Target group name for app tier "
  
}

variable "db-username" {
    description = "Username for the db"
  
}

variable "db-password" {
    description = "Password for the db"
}

variable "db-name" {
    description = "Name of the db"
  
}

variable "instance-class" {
    description = "Value for the db instance class"
  
}

variable "db-sg-name" {
    description = "Name of the sec group for the db instances"
  
}

variable "db-subnet-grp-name" {
    description = "Name for the subnet group"
  
}

variable "app-db-sg-name" {
    description = "Name for the app-db sec"
  
}