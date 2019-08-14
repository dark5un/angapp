module "ecr_angapp" {
    source = "./modules/ecr"

    name = "angapp"
    environment = "angapp"
}

module "ecr_nginx" {
    source = "./modules/ecr"

    name = "nginx"
    environment = "angapp"
}

module "network" {
    source = "./modules/network"

    environment = "angapp"
}

module "ecs" {
    source = "./modules/ecs"

    front_end_listener = module.network.front_end_listener
    alb_target_group = module.network.alb_target_group
    vpc_id = module.network.vpc_id
    ecs_tasks_security_group_id = module.network.ecs_tasks_security_group_id
    environment = "angapp"
}
