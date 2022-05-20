resource "aws_cloudfront_origin_access_identity" "cloudfront_origin_access_identity" {
  comment    = "Only This User is allowed for S3 Read bucket"
}


resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    
    domain_name = "arans3.s3.us-east-1.amazonaws.com"
    origin_id = "arans3.s3.us-east-1.amazonaws.com"

  s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity.cloudfront_access_identity_path
    }
  }
    enabled = true
    default_root_object = "index.html"
    
default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "arans3.s3.us-east-1.amazonaws.com"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }



viewer_certificate {
    cloudfront_default_certificate = true
  }
}

