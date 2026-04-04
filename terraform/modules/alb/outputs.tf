output "tg_arn" {
  value = aws_lb_target_group.main_tg.arn
}

output "alb_dns_name" {
  value = aws_lb.main_alb.dns_name
}