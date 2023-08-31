resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  count = 3

  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = "us-east-1a"  # Change the AZ as needed

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 3

  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.${count.index + 10}.0/24"
  availability_zone = "us-east-1a"  # Change the AZ as needed

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_instance" "nat_instance" {
  ami           = "ami-0def9f1558e16257f"  # Replace with actual NAT instance AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet[0].id  # Use one of the public subnets

  tags = {
    Name = "nat-instance"
  }
}