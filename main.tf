terraform {
  

   backend "s3" {
    bucket         = "mytest123-bucket"
    key            = "terraform/terra123.state"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"


  }

resource "aws_instance" "mytest123-server" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"
    key_name = "practice"
  subnet_id = aws_subnet.mytest123_subnet.id
  vpc_security_group_ids = [ aws_security_group.mytest123-vpc-sg.id]
}
 
# VPC
resource "aws_vpc" "mytest123-vpc" {
    cidr_block = "10.10.0.0/16"
    
      
    }
  


#sub
resource "aws_subnet" "mytest123_subnet" {
    vpc_id = aws_vpc.mytest123-vpc.id
    cidr_block = "10.10.1.0/24"

    tags = {
      Name = "mytest123_subnet"
    }
  
}

#igw 
resource "aws_internet_gateway" "mytest123-igw" {
    vpc_id = aws_vpc.mytest123-vpc.id
    tags = {
      Name = "mytest123-igw"
    }
}

#rt
resource "aws_route_table" "mytest123-rt" {
    vpc_id = aws_vpc.mytest123-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.mytest123-igw.id
    }
    tags  =  {
        Name = "mytest123-rt"
    }
}

# Associate subnet with routetable 

resource "aws_route_table_association" "mytest123-rt_association" {
    subnet_id = aws_subnet.mytest123_subnet.id
    route_table_id = aws_route_table.mytest123-rt.id
}
  

  
resource "aws_security_group" "mytest123-vpc-sg" {
  name        = "mytest123-vpc-sg"
  vpc_id      = aws_vpc.mytest123-vpc.id

  ingress {
    
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mytest123"
  }
}