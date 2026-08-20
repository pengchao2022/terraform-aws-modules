output "nlb_dns_name" {
  value = aws_lb.rabbitmq_nlb.dns_name
  description = "以后你的 Python 代码只需要连接这个 DNS 地址"
}