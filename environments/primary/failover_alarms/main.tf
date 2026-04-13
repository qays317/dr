/*
===================================================================================================================================================================
===================================================================================================================================================================
                                                           CloudWatch Alarm
===================================================================================================================================================================
===================================================================================================================================================================
*/

# CloudWatch alarm to monitor ECS service health via ALB target group
resource "aws_cloudwatch_metric_alarm" "ecs_health_alarm" {
  alarm_name = "wordpress-health-alarm"
  alarm_description = "Monitor healthy ECS tasks"
  namespace = "AWS/ApplicationELB"
  metric_name = "HealthyHostCount"
  statistic = "Average"
  threshold = 2
  comparison_operator = "LessThanThreshold"
  period = 60
  evaluation_periods = 1
  treat_missing_data = "breaching"
  alarm_actions = []
  dimensions = {
    TargetGroup = var.target_group_arn_suffix
    LoadBalancer = var.load_balancer_arn_suffix
  }
  tags = { Name = "wordpress-health-alarm" }
}
