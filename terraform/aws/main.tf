# Grupo de Segurança que permitir o tráfego HTTP e SSH
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Criação das Instâncias EC2 em uma única zona de disponibilidade
resource "aws_instance" "web" {
  count                  = 2
  ami                    = "ami-02e136e904f3da870"
  instance_type          = "t2.micro"
  security_groups        = [aws_security_group.allow_http.name]
  availability_zone      = "us-east-1a"



}

# Load Balancer em uma única zona de disponibilidade
resource "aws_elb" "web_elb" {
  name               = "web-nader-lb"
  availability_zones = ["us-east-1a"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = aws_instance.web.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "web-nader-lb"
  }
}


# DATA # -----------------------------------------------------------------------------------------

data "template_file" "user_data" {
  template = file("./script/user_data.sh")
  vars = {
    efs_id = aws_efs_file_system.efs.id
  }
}


# LOAD BALANCER 

# resource "aws_lb" "lb" {
#   name               = "lb-1"
#   load_balancer_type = "application"
#   subnets            = [aws_subnet.sn1.id, aws_subnet.sn2.id]
#   security_groups    = [aws_security_group.sg.id]
# }

# resource "aws_lb_target_group" "tg" {
#   name     = "tg-1"
#   protocol = "HTTP"
#   port     = "80"
#   vpc_id   = aws_vpc.vpc.id
# }

# resource "aws_lb_listener" "ec2_lb_listener" {
#   protocol          = "HTTP"
#   port              = "80"
#   load_balancer_arn = aws_lb.lb.arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#   }
# }



