resource "aws_security_group" "asg-security_group-web" {
    name = var.asg-sg-web-name
    description = "auto scaling group sec group"
    vpc_id = aws_vpc.vpc.id
    

    ingress {
        description = "HTTP from ALB" #like in lab
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [ aws_security_group.alb-security-group-web.id ]
    }

    ingress {
        description = "SSH connection from anywhere (should be my ip ¯_(ツ)_/¯)"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ 0.0.0.0/0 ]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ 0.0.0.0/0 ]
    }

    tags = { Name=var.asg-sg-web-name }

}