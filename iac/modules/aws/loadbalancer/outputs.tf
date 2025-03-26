output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = aws_lb.main.id
}

output "dns_name" {
  description = "Our configured domain name for the load balancer (used for SSL termination)"
  value       = "${var.environment}.${var.hosted_zone_dns_name}"
}

output "load_balancer_dns" {
  description = "The actual ALB DNS name (AWS generated)"
  value       = aws_lb.main.dns_name
}

output "security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}

output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.main.arn
}
