# Database Security Group
resource "aws_security_group" "db-sg" {
    name = var.db-sg-name
    description = "DB sec group"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [ aws_security_group.asg-security-group-app.id ]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    
    tags = {Name = var.db-sg-name}
}

# Database Subnet Group
resource "aws_db_subnet_group" "subnet-grp" {
    name = var.db-subnet-grp-name
    subnet_ids = [ aws_subnet.db-subnet1.id, aws_subnet.db-subnet2.id ]

    tags = {
      Name = var.db-subnet-grp-name
    }
}

# RDS MySQL Database
resource "aws_db_instance" "rds-db" {
    allocated_storage = 10
    db_name = var.db-name
    engine = "mysql"
    engine_version = "5.7"
    instance_class = var.instance-class
    username = var.db-username
    password = var.db-password
    parameter_group_name = "default.mysql5.7"
    multi_az = true
    db_subnet_group_name = aws_db_subnet_group.subnet-grp.name
    vpc_security_group_ids = [ aws_security_group.db-sg.id ]
    skip_final_snapshot = true
}
