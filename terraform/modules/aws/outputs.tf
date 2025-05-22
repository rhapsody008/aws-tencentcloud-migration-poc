output "aws_alb_dns_name" {
    description = "The DNS name of the ALB"
    value       = aws_lb.zy_test_aws_alb.dns_name
}