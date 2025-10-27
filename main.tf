# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.my_subnets["subnet1"].id
  route_table_id = aws_route_table.rt.id
}

resource "aws_subnet" "my_subnets" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags = {
    Name = each.key
  }

}
resource "aws_instance" "test-ec2" {
  ami = data.aws_ami.ubuntu.id
  for_each = toset(var.azs)
  subnet_id = aws_subnet.my_subnets["subnet1"].id
  instance_type = "t3.micro"
  availability_zone = "us-east-1a"
  associate_public_ip_address = true
  tags = {
    Name = "test-ec2"
  }
  key_name = var.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apache2",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "echo '<h1>Apache installed successfully on ${self.public_dns}</h1>' | sudo tee /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/my-key.pem")
      host        = self.public_ip
    }
  }
  
}
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
