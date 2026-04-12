ecs_task_definition_config = {
    family = "wordpress-task"
    cpu = "1024"
    memory = "2048"
    rds_name = "mysql"
}


ecs_task_desired_count = 2
