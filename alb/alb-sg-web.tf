resource "aws_security_group" "alb-security-group-web" {
    name = var.alb-sg-web-name
    description = "AlB Sec group"
    vpc_id = aws_vpc.vpc.id

    ingress {
        description = "HTTP FROM INTERNET"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    
    #all allowed definition (-1 all protocols allowed) (when protocol -1 aws ignores ports)
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.alb-sg-web-name
    }
}