output "app_endpoint" {
  value = aws_alb.application_load_balancer.dns_name
}
