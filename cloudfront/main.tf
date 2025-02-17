data "aws_caller_identity" "current" {}


resource "aws_s3_bucket" "static" {
  bucket = var.static_bucket_name
  tags = {
    Usage = "static-files"
  }
}

resource "aws_s3_bucket_acl" "static_acl" {
  bucket = aws_s3_bucket.static.id
  acl    = "private"
  depends_on = [
    aws_s3_bucket_ownership_controls.static_owner,
  ]
}

resource "aws_s3_bucket_ownership_controls" "static_owner" {
  bucket = aws_s3_bucket.static.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket" "django_static" {
  bucket = var.django_static_bucket_name
  tags = {
    Usage = "django-static-files"
  }
}

resource "aws_s3_bucket_acl" "django_static_acl" {
  bucket = aws_s3_bucket.django_static.id
  acl    = "private"
  depends_on = [
    aws_s3_bucket_ownership_controls.django_static_owner
  ]
}

resource "aws_s3_bucket_ownership_controls" "django_static_owner" {
  bucket = aws_s3_bucket.django_static.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

data "aws_iam_policy_document" "static_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
    sid = "1"
  }
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.static.arn}"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
    sid = "2"
  }
  depends_on = [
    aws_s3_bucket.django_static,
    aws_cloudfront_origin_access_identity.origin_access_identity
  ]
}

data "aws_iam_policy_document" "django_static_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.django_static.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
    sid = "1"
  }
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.django_static.arn}"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
    sid = "2"
  }
  depends_on = [
    aws_s3_bucket.django_static,
    aws_cloudfront_origin_access_identity.origin_access_identity
  ]
}

resource "aws_cloudfront_origin_request_policy" "S3_request_policy" {
  name    = "S3_request_policy-${var.project_name}-${var.environment}"
  comment = "S3 request policy for CDN"
  cookies_config {
    cookie_behavior = "none"
    #    cookies {
    #      items = ["example"]
    #    }
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["origin", "access-control-request-headers", "access-control-request-method"]
    }
  }
  query_strings_config {
    query_string_behavior = "none"
    #    query_strings {
    #      items = ["example"]
    #    }
  }
}

resource "aws_cloudfront_cache_policy" "S3_cache_policy" {
  name        = "S3_cache_policy-${var.project_name}-${var.environment}"
  comment     = "S3 cache policy for CDN"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
      #      cookies {
      #        items = ["example"]
      #      }
    }
    headers_config {
      header_behavior = "none"
      #      headers {
      #        items = ["example"]
      #      }
    }
    query_strings_config {
      query_string_behavior = "none"
      #      query_strings {
      #        items = ["example"]
      #      }
    }
  }
}

## Attachment policy to the bucket
resource "aws_s3_bucket_policy" "cf_s3_bucket_policy" {
  depends_on = [aws_s3_bucket.static]
  bucket     = aws_s3_bucket.static.id
  policy     = data.aws_iam_policy_document.static_policy.json
}

resource "aws_s3_bucket_policy" "cf_s3_django_bucket_policy" {
  depends_on = [aws_s3_bucket.django_static]
  bucket     = aws_s3_bucket.django_static.id
  policy     = data.aws_iam_policy_document.django_static_policy.json
}

resource "aws_s3_bucket_cors_configuration" "static_cors" {
  depends_on = [aws_s3_bucket.static]
  bucket     = aws_s3_bucket.static.bucket
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_cors_configuration" "django_static_cors" {
  depends_on = [aws_s3_bucket.django_static]
  bucket     = aws_s3_bucket.django_static.bucket
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    allowed_headers = ["Authorization"]
  }
}

resource "aws_s3_bucket" "logs" {
  bucket        = var.logs_bucket_name
  force_destroy = true
  tags = {
    Usage = "cloudfront-logs"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_bucket_lifecycle" {
  bucket = aws_s3_bucket.logs.id
  rule {
    id     = "remove_files_10_days"
    status = "Enabled"
    filter {}
    #    expiration {
    #      days = 10
    #    }
    noncurrent_version_expiration {
      noncurrent_days = 10
    }
  }
}
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "logs_owner" {
  bucket = aws_s3_bucket.logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "logs_acl" {
  bucket = aws_s3_bucket.logs.id
  acl    = "private"
  depends_on = [
    aws_s3_bucket_ownership_controls.logs_owner
  ]
}

## CDN config
resource "aws_cloudfront_distribution" "this" {
  depends_on = [
    aws_s3_bucket.static,
    aws_s3_bucket.logs,
    aws_cloudfront_origin_request_policy.S3_request_policy,
    aws_cloudfront_cache_policy.S3_cache_policy
  ]
  # By default, show index.html file
  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    prefix          = ""
  }

  aliases = [var.dns_name]

  web_acl_id = var.waf_web_acl_id

  origin {
    domain_name = aws_s3_bucket.static.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.static.bucket}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  origin {
    domain_name = aws_s3_bucket.django_static.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.django_static.bucket}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  origin {
    domain_name         = var.elb_dns_name
    origin_id           = "api-alb"
    connection_timeout  = 10
    connection_attempts = 3
    custom_origin_config {
      http_port                = var.frontend_port
      https_port               = var.frontend_ssl_port
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_read_timeout      = 60
      origin_keepalive_timeout = 60
    }
    custom_header {
      name  = "X-custom-header"
      value = var.custom_header_value
    }
  }

  # If there is a 404, return index.html with a HTTP 200 Response
  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 404
    response_code         = 404
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-${aws_s3_bucket.static.bucket}"

    viewer_protocol_policy   = "redirect-to-https"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.S3_request_policy.id
    cache_policy_id          = aws_cloudfront_cache_policy.S3_cache_policy.id
    compress                 = true

  }

  ordered_cache_behavior {
    path_pattern     = "api/*"
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "api-alb"
    forwarded_values {
      query_string = true
      headers      = ["Origin", "Host", "Authorization", "Accept", "Accept-Encoding", "CloudFront-Forwarded-Proto", "Authority"]
      cookies {
        forward = "all"
      }
    }
    #viewer_protocol_policy = "allow-all"
    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern     = "admin/*"
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "api-alb"
    forwarded_values {
      query_string = true
      headers      = ["Origin", "Host", "Authorization", "Accept", "Accept-Encoding", "CloudFront-Forwarded-Proto", "Authority"]
      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern     = "static_files/*"
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.django_static.bucket}"

    viewer_protocol_policy   = "redirect-to-https"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.S3_request_policy.id
    cache_policy_id          = aws_cloudfront_cache_policy.S3_cache_policy.id
    compress                 = true
  }

  # Distributes content to US and Europe
  price_class = "PriceClass_100"
  # Restricts who is able to access this content
  restrictions {
    geo_restriction {
      restriction_type = lookup(var.restrictions, "type", "none")
      locations        = lookup(var.restrictions, "locations", [])
    }
  }

  # SSL certificate for the service.
  viewer_certificate {
    acm_certificate_arn      = var.https_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  #  viewer_certificate {
  #    cloudfront_default_certificate = true
  #  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront-webapp-origin"
}

