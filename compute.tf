# Web Tier Security Group
resource "aws_security_group" "asg-security-group-web" {
    name = var.asg-sg-web-name
    description = "auto scaling group sec group"
    vpc_id = aws_vpc.vpc.id
    
    ingress {
        description = "HTTP from ALB"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [ aws_security_group.alb-security-group-web.id ]
    }

    ingress {
        description = "SSH connection from anywhere (consider restricting to your IP)"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = { Name=var.asg-sg-web-name }
}

# App Tier Security Group
resource "aws_security_group" "asg-security-group-app" {
    name = var.asg-sg-app-name
    description = "ASG security group for the app asg"
    vpc_id = aws_vpc.vpc.id

    ingress {
        description = "HTTP from alb app"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [ aws_security_group.alb-security-group-app.id ]
    }

    ingress {
        description = "SSH FROM ANYWHERE"
        from_port = 22 
        to_port = 22
        protocol = "tcp"
        security_groups = [ aws_security_group.asg-security-group-web.id ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {Name=var.asg-sg-app-name}
}

# Web Tier Launch Template
resource "aws_launch_template" "template-web" {
    name = var.launch-template-web-name
    image_id = var.image-id
    instance_type = var.instance-type
    key_name = aws_key_pair.ec2_key_pair.key_name

    network_interfaces {
      device_index = 0
      security_groups = [ aws_security_group.asg-security-group-web.id ]
    }
    
    user_data = filebase64("${path.module}/user-data.sh")

    tag_specifications {
      resource_type = "instance"
      tags = {Name = var.web-instance-name}
    }
}

# App Tier Launch Template
resource "aws_launch_template" "template-app" {
  name = var.launch-template-app-name
  image_id = var.image-id
  instance_type = var.instance-type
  key_name = aws_key_pair.ec2_key_pair.key_name

  network_interfaces {
    device_index = 0
    security_groups = [ aws_security_group.asg-security-group-app.id ]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
        Name = var.app-instance-name
    }
  }
}

# Web Tier Auto Scaling Group
resource "aws_autoscaling_group" "asg-web" {
    name = var.asg-web-name
    desired_capacity = 2
    max_size = 4
    min_size = 1
    target_group_arns = [ aws_lb_target_group.target-group-web.arn ]
    health_check_type = "EC2"
    vpc_zone_identifier = [ aws_subnet.web-subnet1.id, aws_subnet.web-subnet2.id ]
    
    launch_template {
      id = aws_launch_template.template-web.id
      version = aws_launch_template.template-web.latest_version
    }
}

# App Tier Auto Scaling Group
resource "aws_autoscaling_group" "app-asg" {
    name = var.asg-app-name
    desired_capacity = 2
    max_size = 2
    min_size = 1
    target_group_arns = [ aws_lb_target_group.target-group-app.arn ]
    health_check_type = "EC2"
    vpc_zone_identifier = [ aws_subnet.app-subnet1.id, aws_subnet.app-subnet2.id ]

    launch_template {
      id = aws_launch_template.template-app.id
      version = aws_launch_template.template-app.latest_version
    }
}
