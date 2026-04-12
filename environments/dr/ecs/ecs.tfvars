

ecr_image_uri = ""

ecs_task_definition_config = {
    family = "wordpress-task"
    cpu = "1024"
    memory = "2048"
}

ecs_service_config = {
    desired_count = 0
    network_configuration = {
        security_group_name = "wordpress-service-SG"
    }
}

vpc_endpoints_config = {
    "logs" = "Interface",
    "s3" = "Gateway", 
    "ecs" = "Interface",
    "sts" = "Interface",
    "monitoring" = "Interface",
    "ecr.api" = "Interface",
    "ecr.dkr" = "Interface",
    "ssmmessages" = "Interface",
    "ssm" = "Interface",
    "ec2messages" = "Interface",
    "secretsmanager" = "Interface"
}


