resource "aws_ecs_cluster" "main" {
  name = "tf-ecs-cluster"

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "proxy"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "4096"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.app_image}",
    "memory": ${var.fargate_memory},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/fargate/service/${var.environment}",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  },
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.proxy_image}",
    "memory": ${var.fargate_memory},
    "name": "proxy",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/fargate/service/${var.environment}",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "${var.environment}-ecs"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_subnet_ids" "private" {                              
  vpc_id = var.vpc_id                             
  tags = {
    Tier = "Private"
  }
}

# data "aws_subnet" "private" {
#   count = "${length(data.aws_subnet_ids.private.ids)}"
#   id    = "${data.aws_subnet_ids.private.ids[count.index]}"
# }

resource "aws_ecs_service" "main" {
  name            = "tf-ecs-service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${var.ecs_tasks_security_group_id}"]
    subnets         = data.aws_subnet_ids.private.ids
  }

  load_balancer {
    target_group_arn = "${var.alb_target_group.id}"
    container_name   = "proxy"
    container_port   = "${var.app_port}"
  }

  # depends_on = [
  #   "aws_alb_listener.front_end",
  # ]

  # tags = {
  #   Environment = var.environment
  # }
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/fargate/service/${var.environment}"
  retention_in_days = "14"
}