variable "tags" {
  type = map
  default = {
    Name = "Provisioner"
    Terraform = "true"
    Environment = "DEV"
  }
}

variable "vpc_cidr" {
  type = string
  default = "10.10.0.0/16"
}

variable "subnet_cidr" {
  type = string
  default = "10.10.1.0/24"
}

variable "ingress" {
  type = map
  default = {
    
    postgress = {
    description      = "Allow 443 port"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    },
    http = {
    description      = "Allow 80 port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    },
    Jenkins = {
    description      = "Allow 8080 port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    },
    ssh = {
    description      = "Allow 22 port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  }
  
}