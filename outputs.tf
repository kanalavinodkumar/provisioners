output "internet_gateway" {
  value = aws_internet_gateway.main.id
}

output "vpc" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.id
}

output "public_rt" {
  value = aws_route_table.public_rt.id
}

output "sg" {
  value = aws_security_group.sg.id
}

output "EC2_public_ip" {
  value = aws_instance.EC2.public_ip
}
