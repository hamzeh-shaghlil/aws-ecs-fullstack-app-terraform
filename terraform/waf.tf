resource "aws_wafv2_web_acl" "wafv2" {
  name        = "${var.app}-WAF"
  description = "managed rule"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1


override_action {
      none {}
    }
 
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
     }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.app}-rule-metric"
      sampled_requests_enabled   = false
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.app}-metric-name"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "waf-alb" {
  resource_arn = aws_lb.app-lb.arn
  web_acl_arn   = aws_wafv2_web_acl.wafv2.arn
}