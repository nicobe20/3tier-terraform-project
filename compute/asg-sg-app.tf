resource "aws_security_group" "asg-security-group-app" {
    name = var.asg-sg-app-name
    description = "ASG security group for the app asg"
    vpc_id = aws_vpc.vpc.id


    ingress {
        description = "HTTP from alb app (remember the lab same thing)"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [ aws_security_group.alb-security_group-app.id ]
    
    }

    ingress {
        description = "SSH FROM ANYWHERE "
        from_port = 22 
        to_port = 22
        protocol = "tcp"
        security_groups = [ aws_security_group.asg-security_group-web.id ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]

    }

    tags = {Name=var.asg-sg-app-name}
  
}