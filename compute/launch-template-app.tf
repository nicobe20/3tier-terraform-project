resource "aws_launch_template" "template-app" {
  name = var.launch-template-app-name
  image_id = var.image-id
  instance_type = var.instance-ype
  key_name = var.key-name

  network_interfaces {
    device_index = 0
    security_groups = [ aws_security_group.asg-security_group-web.id ]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
        Name = var.app-instance-name
    }


  }

}