
// In this file
//  1.  Created first Security Group for the ec2-instance
//  2.  Then Created one ec2-instance in public subnet.
//  3.  Created one ec2-instance in private subnet.



//  1. ======== Creating first Security Group for the ec2-instance. =======
//  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
//  ======================================================================
resource "aws_security_group" "my_sg" {
  name        = "Private_ec_sg"
   description = "Allow All inbound traffic"
   vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

output "aws_security_gr_id"{  
    value = "${aws_security_group.my_sg.id}"
}



// 2. ======== Creating EC2 instance in the public subnet. =======
resource "aws_instance" "public_instance" {
  ami                    = "ami-0fb974a4772b174a5"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id   # ID of the private subnet to launch the instance in
  key_name               = "newkey"
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "Public Instance"
  }
}


// 3. ======== Creating EC2 instance in the private subnet. =======
resource "aws_instance" "private_instance" {
  ami           = "ami-0fb974a4772b174a5" 
  instance_type = "t2.micro"  
  subnet_id     = aws_subnet.private_subnet.id  
  key_name      = "newkey" 
  count         = 1
  associate_public_ip_address = false

  # Security group configuration (example: allowing SSH access)
  vpc_security_group_ids = ["${aws_security_group.my_sg.id}"]   # Replace this with your desired security group ID(s)

  tags = {
    Name = "Private Instance"  
  }
}
