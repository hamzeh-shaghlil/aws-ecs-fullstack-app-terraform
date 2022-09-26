# AWS Application Loadbalancer
resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs-alb.id]
  subnets            = ["${aws_subnet.pub-subnets[0].id}", "${aws_subnet.pub-subnets[1].id}"]

}
# AWS Loadbalancer TargetGroup
resource "aws_lb_target_group" "tg-group" {
  name        = "tg-group"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.ecs-vpc.id}"
  target_type = "ip"
  health_check {
   path                = "/live"
     healthy_threshold   = 6
     unhealthy_threshold = 2
     timeout             = 2
     interval            = 15
     matcher             = "200" # has to be HTTP 200 or fails
   }

}
# AWS Application Loadbalancer Listner
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = "${aws_lb.app-lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
  }
}

