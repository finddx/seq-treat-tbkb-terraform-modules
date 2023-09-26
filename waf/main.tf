data "aws_cloudfront_distribution" "cf" {
  id = var.cf_distribution_id
}
output "cloudfront_arn" {
  value = data.aws_cloudfront_distribution.cf.arn
}


resource "aws_wafv2_web_acl" "waf_acl_cf" {
  name ="acl0"
  description ="WAF Web ACL"
  scope = "CLOUDFRONT"
  default_action {
    allow {} #temporarily allows everything, replace it with block {} when needed 
  }
  visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "cf-waf-metric"
      sampled_requests_enabled   = false
    }


    rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 10

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }


  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 30

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationListMetric"
      sampled_requests_enabled   = true
    }
  }



     rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 40

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }
}
/*
resource "aws_wafv2_web_acl_association" "waf_acl_association_cf" {
  resource_arn = "${data.aws_cloudfront_distribution.cf.arn}"
  web_acl_arn  = aws_wafv2_web_acl.waf_acl_cf.arn
}
*/


########################################################################################################

resource "aws_wafv2_web_acl" "waf_acl_lb" {
  name ="acl1"
  description ="WAF Web ACL"
  scope = "REGIONAL"
  default_action {
    allow {} #temporarily allows everything, replace it with block {} when needed 
  }
  visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "lb-waf-metric"
      sampled_requests_enabled   = false
    }


    rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 50

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }


  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 60

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 70

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationListMetric"
      sampled_requests_enabled   = true
    }
  }



     rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 80

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "waf_acl_association_lb" {
  resource_arn = "${var.lb_arn}"
  web_acl_arn  = aws_wafv2_web_acl.waf_acl_lb.arn
}



########################################################################################################