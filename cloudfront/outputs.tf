output "distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}


output "distribution_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}
