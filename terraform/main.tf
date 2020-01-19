
provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "login" {
  key_name      = "login-key"
  public_key    = file("./ec2.key.pub")
}

resource "aws_spot_instance_request" "spot-t0" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "a1.medium"
  spot_price    = "0.0050"
  spot_type = "one-time"
  wait_for_fulfillment = true
  vpc_security_group_ids = [aws_security_group.spot-default.id]
  tags = {
    Name = "spot-t0"
  }

 key_name = "login-key"
}

resource "aws_security_group" "spot-default" {

  name = "spot-default"

  # Inbound HTTP from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
