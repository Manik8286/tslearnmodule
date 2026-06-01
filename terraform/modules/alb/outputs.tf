output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.lb.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.lb.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.alb_tg.arn
}

output "listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.front_end.arn
}
