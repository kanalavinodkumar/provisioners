resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = var.tags
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = var.tags
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#SG
resource "aws_security_group" "sg" {
  name = "Provisioner-SG"
  description = "SG"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      description = ingress.value.description
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = merge(var.tags,{
                Name = "Provisioner-SG"
            })
}

resource "aws_key_pair" "provisioners" {
  key_name   = "provisioners"
  public_key = file("provisioners.pub")
}

 resource "aws_instance" "EC2" {
    ami = "ami-018ba43095ff50d08"
    instance_type = "t2.micro"
    key_name = aws_key_pair.provisioners.key_name
    subnet_id = aws_subnet.public_subnet.id
    security_groups = ["${aws_security_group.sg.id}"]
    #user_data = file("scripts/docker.sh")
    tags = merge(var.tags,{
                Name = "Docker-workstation"
            })
    
    #local-exec
    provisioner "local-exec" {
      command = "echo Hey Vinod !!! public ip : ${self.public_ip} > public_ip.txt"
    }

    #remote-exec
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("provisioners.pem")
      host     = self.public_ip
    }
    provisioner "remote-exec" {
      inline = [ 
        "echo Hey Vinod !!! public ip : ${self.public_ip} > public_ip.txt"
       ]
    }
    provisioner "remote-exec" {
      script = "scripts/docker.sh"
    }
}