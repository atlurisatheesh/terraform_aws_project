resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
  
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "myig" {
    vpc_id = aws_vpc.myvpc.id
  
}

resource "aws_route_table" "myRT" {
  vpc_id = aws_vpc.myvpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myig.id
  }

}

resource "aws_route_table_association" "myrt1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.myRT.id
  
}

resource "aws_route_table_association" "myrt2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.myRT.id
  
}

resource "aws_security_group" "mySG" {
    name = "web"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        description = "Allow fro HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        description = "Allow fro ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      name = "my-sg-allowall"
    }
}

resource "aws_s3_bucket" "myS3" {
    bucket = "atluri-terraform-s3-bucket"
  
}

resource "aws_instance" "myinstance1" {
    ami = "ami-04b70fa74e45c3917"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.mySG.id]
    subnet_id = aws_subnet.sub1.id

    tags = {
        name = "aws_pro1"
    }
      
}

resource "aws_instance" "myinstance2" {
    ami = "ami-04b70fa74e45c3917"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.mySG.id]
    subnet_id = aws_subnet.sub2.id
      
      tags = {
        name = "aws-pro2"
      }
}

