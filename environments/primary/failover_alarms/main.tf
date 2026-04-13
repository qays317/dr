data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = var.state_bucket_name
    key = "environments/primary/alb/terraform.tfstate"
    region = var.state_bucket_region
  }
}


/*
===================================================================================================================================================================
===================================================================================================================================================================
                                                           CloudWatch Alarms
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
    TargetGroup = data.terraform_remote_state.alb.outputs.target_group_arn_suffix 
    LoadBalancer = data.terraform_remote_state.alb.outputs.alb_arn_suffix
  }

  tags = { Name = "wordpress-health-alarm" }
}


resource "aws_cloudwatch_metric_alarm" "ecs_running_tasks_alarm" {
  alarm_name = "wordpress-ecs-running-low"
  alarm_description = "Alarm when ECS running task count is lower than expected"
  namespace = "AWS/ECS"
  metric_name = "RunningTaskCount"
  statistic = "Average"
  threshold = 2
  comparison_operator = "LessThanThreshold"
  period = 60
  evaluation_periods = 1
  treat_missing_data = "breaching"
  alarm_actions = []

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = {
    Name = "wordpress-ecs-running-low"
  }
}


resource "aws_cloudwatch_composite_alarm" "failover_trigger_alarm" {
  alarm_name = "wordpress-failover-composite-alarm"
  alarm_description = "Trigger failover only when ALB health and ECS running task count both indicate a real incident"

  alarm_rule = join(" AND ", [
    "ALARM(\"${aws_cloudwatch_metric_alarm.ecs_health_alarm.alarm_name}\")",
    "ALARM(\"${aws_cloudwatch_metric_alarm.ecs_running_tasks_alarm.alarm_name}\")"
  ])

  alarm_actions = []

  tags = {
    Name = "wordpress-failover-composite-alarm"
  }
}



/*
===================================================================================================================================================================
===================================================================================================================================================================
                                                              EventBridge Rule
===================================================================================================================================================================
===================================================================================================================================================================
*/

resource "aws_cloudwatch_event_rule" "failover_alarm_rule" {
  name        = "wordpress-failover-alarm-rule"
  description = "Start DR Step Function when composite failover alarm enters ALARM state"

  event_pattern = jsonencode({
    source      = ["aws.cloudwatch"]
    "detail-type" = ["CloudWatch Alarm State Change"]
    resources   = [aws_cloudwatch_composite_alarm.failover_trigger_alarm.arn]
    detail = {
      state = {
        value = ["ALARM"]
      }
    }
  })
}




