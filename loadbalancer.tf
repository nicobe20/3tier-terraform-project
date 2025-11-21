# Web Tier ALB Security Group
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

# App Tier ALB Security Group
resource "aws_security_group" "alb-security-group-app" {
    name = var.alb-sg-app-name
    description = "ALB sec group for app alb"
    vpc_id = aws_vpc.vpc.id

    ingress {
        description = "HTTP from the web app tier"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [ aws_security_group.alb-security-group-web.id ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
    tags = {
        Name = var.alb-sg-app-name
    }
}

# Web Tier Application Load Balancer
resource "aws_lb" "alb-web" {
    name = var.alb-web-name
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb-security-group-web.id]
    subnets = [aws_subnet.web-subnet1.id, aws_subnet.web-subnet2.id]
}

# App Tier Application Load Balancer (Internal)
resource "aws_lb" "alb-app" {
  name = var.alb-app-name
  internal = true
  load_balancer_type = "application"
  security_groups = [ aws_security_group.alb-security-group-app.id ]
  subnets = [ aws_subnet.app-subnet1.id, aws_subnet.app-subnet2.id  ]
}

# Web Tier Target Group
resource "aws_lb_target_group" "target-group-web" {
    name = var.tg-web-name
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
    
    health_check {
      path = "/"
      matcher = 200
    }
}

# Web Tier ALB Listener
resource "aws_lb_listener" "alb_listener-web" {
    load_balancer_arn = aws_lb.alb-web.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.target-group-web.arn
    }
}

# App Tier Target Group
resource "aws_lb_target_group" "target-group-app" {
    name = var.tg-app-name
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
    
    health_check {
      path = "/"
      matcher = 200
    }
}

# App Tier ALB Listener
resource "aws_lb_listener" "alb-listener-app" {
    load_balancer_arn = aws_lb.alb-app.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.target-group-app.arn
    }
}
