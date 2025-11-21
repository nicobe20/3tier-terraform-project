resource "aws_lb" "alb-app" { #this is also named (internal alb in the lab)
  name = var.alb-app-name
  load_balancer_type = "application"
  security_groups = [ aws_security_group.alb-security-group-app.id ]
  subnets = [ aws_subnet.app-subnet1.id, aws_subnet.app-subnet2.id  ]
  internal = true

}