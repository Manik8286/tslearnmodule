resource "aws_ecs_cluster" "ts_cluster" {
  name = "ts-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task_app" {
  family                   = "task-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([{
    name      = "task-app"
    image     = var.app_image
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 8000
      protocol      = "tcp"
    }]
  }])
}

resource "aws_ecs_service" "task_service" {
  name            = "task-service"
  cluster         = aws_ecs_cluster.ts_cluster.id
  task_definition = aws_ecs_task_definition.task_app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.app_subnet_id]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "task-app"
    container_port   = 8000
  }

  depends_on = [var.listener_arn]
}
