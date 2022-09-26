output "alb_dns" {
  value = "Use this endpoint to access the app --> ${aws_lb.app-lb.dns_name}/live"
  description = "LoadBalancer Endpoint"
}


