resource "aws_route_table" "private-route-table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gw.id
    }
  
    tags = {Name = var.private-rt-name}

}

resource "aws_route_table_association" "pri-rt-association1" {
    subnet_id = aws_subnet.app-subnet1.id
    route_table_id = aws_route_table.private-route-table.id

}

resource "aws_route_table_association" "pri-rt-association2" {
    subnet_id = aws_subnet.app-subnet2.id
    route_table_id = aws_route_table.private-route-table.id

}   

#THIS MAKES SOOOO MUCH SENSE BRO (nat so that the pri instances can access internet but not viceversa)