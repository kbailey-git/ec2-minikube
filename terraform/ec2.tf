provider "aws" {
  region = "us-west-1"
}

resource "aws_security_group" "sg" {
  name          = "sg"
  description   = "Web Security Group for HTTP"
}

resource "aws_security_group_rule" "allow_app_port" {
  security_group_id = aws_security_group.sg.id
  type        = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 3000
  protocol    = "tcp"
  to_port     = 3000
}

resource "aws_security_group_rule" "allow_k8_actions" {
  security_group_id = aws_security_group.sg.id
  type        = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 6443
  protocol    = "tcp"
  to_port     = 6443
}

resource "aws_security_group_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg.id
  type        = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 22
  protocol    = "tcp"
  to_port     = 22
}

resource "aws_security_group_rule" "allow_outbound" {
    security_group_id = aws_security_group.sg.id
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]  # Allow to any destination
}

resource "aws_key_pair" "cicd_key" {
  key_name     = "cicd_key"
  public_key   = file("~/.ssh/cicd.pub")
}

resource "aws_instance" "app"{
    ami             = "ami-0657605d763ac72a8"
    instance_type   = "t3.micro"
    key_name        = aws_key_pair.cicd_key.key_name
    security_groups = [aws_security_group.sg.name]
}

output "instance_ip" {
  value = aws_instance.app.public_ip
}