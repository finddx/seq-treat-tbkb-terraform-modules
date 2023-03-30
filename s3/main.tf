locals {
  prefix    = "${var.project_name}-${var.module_name}-${var.environment}"
}

resource "aws_s3_bucket" "default" {
  for_each      = var.s3_buckets
  force_destroy = lookup(each.value, "force_destroy", false)
}


resource "aws_s3_bucket_acl" "default" {
  for_each = {
    for key, value in var.s3_buckets : key => value
    if value.bucket_acl == true
  }
  bucket = aws_s3_bucket.default[each.key].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "default" {
  for_each = {
    for key, value in var.s3_buckets : key => value
    if value.enable_versioning == true
  }
  bucket = aws_s3_bucket.default[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  for_each = var.s3_buckets
  bucket   = aws_s3_bucket.default[each.key].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  for_each = {
    for key, value in var.s3_buckets : key => value
    if value.enable_cors
  }
  bucket = aws_s3_bucket.default[each.key].id
  dynamic "cors_rule" {
    for_each =   {
    for key, value in var.s3_buckets[each.key].cors_rule : key => value
  }

    content {
      id              = try(cors_rule.value.id, null)
      allowed_methods = try(cors_rule.value.allowed_methods)
      allowed_origins = try(cors_rule.value.allowed_origins)
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}