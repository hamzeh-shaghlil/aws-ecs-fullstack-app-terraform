# ECS SecurityGroup
resource "aws_security_group" "ecs-sg" {
  name        = "ECS-SG"
  description = "ECS-SG"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    description      = "Allow ECS Port"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    security_groups =  [aws_security_group.ecs-alb.id]
  }

  egress {
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# ALB SecurityGroup
resource "aws_security_group" "ecs-alb" {
  name        = "ALB-SG"
  description = "ALB-SG"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    description      = "Allow Port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




