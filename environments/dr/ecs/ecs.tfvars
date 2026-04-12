

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




