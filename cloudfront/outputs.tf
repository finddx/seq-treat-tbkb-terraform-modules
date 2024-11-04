output "distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}

output "distribution_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "django-static-bucket" {
  value = aws_s3_bucket.django_static.arn
}

output "static-bucket" {
  value = aws_s3_bucket.static.arn
}

output "cf-logs" {
  value = aws_s3_bucket.logs.arn
}
