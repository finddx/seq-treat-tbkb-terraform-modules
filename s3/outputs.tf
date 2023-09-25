output "bucket_id" {
  description = "The name of the bucket."
  value       = try({ for k, v in aws_s3_bucket.default : k => v.id })
}

output "bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try({ for k, v in aws_s3_bucket.default : k => v.arn })
}
