ecs_security_group_config = {
    wordpress-service-SG = {
        ingress = {
            http = {
                from_port = 80
                to_port = 80 
                ip_protocol = "tcp"
                source_security_group_name = "ALB-SG"
            }
        }
        egress = {
            all = {
                from_port = 0
                to_port = 0
                ip_protocol = "-1"
                cidr_block = "0.0.0.0/0"
            }
        }
    }
    vpc-endpoints-SG = {
        ingress = {
            https = {
                ip_protocol = "tcp"
                from_port = 443
                to_port = 443
                source_security_group_name = "wordpress-service-SG"
            }
        }
    }
}




