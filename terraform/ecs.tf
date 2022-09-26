# ECR REPOSITORY
resource "aws_ecr_repository" "ecr-repo" {
  name = "ecr-repo"
  force_delete = true
}

# ECS CLUSTER
resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.app
  
}

# TASK DEFINITION
resource "aws_ecs_task_definition" "task" {
  family                   = var.app
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs-task.arn
  


  container_definitions = jsonencode([
    {
      name   = "${var.app}-container"
      image  = "${aws_ecr_repository.ecr-repo.repository_url}:latest" #URI
      cpu    = 256
      memory = 512
      secrets= [
      {
        name = "DB_URL",
        valueFrom = aws_secretsmanager_secret.rds.arn
      }
    ]
      environment = [
      {
        name = "PORT",
        value = var.port
      }
    ]
      portMappings = [
        {
          containerPort = "${tonumber(var.port)}"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
          options = {
            awslogs-group = "${aws_cloudwatch_log_group.logs.name}",
            awslogs-region = "us-east-1",
            awslogs-stream-prefix = "ecs"
          }
      }
      
    }
  ])
}
# ECS SERVICE
resource "aws_ecs_service" "svc" {
  name            =  var.app
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.id}"
  desired_count   = 1
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = ["${aws_subnet.nated-subnets[0].id}", "${aws_subnet.nated-subnets[1].id}"]
    security_groups  = ["${aws_security_group.ecs-sg.id}"]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
    container_name   = "${var.app}-container"
    container_port   = var.port
  }
}
# autoscaling

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster.name}/${aws_ecs_service.svc.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs-autoscale-role.arn
}


resource "aws_appautoscaling_policy" "ecs_target_cpu" {
  name               = "application-scaling-policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}
resource "aws_appautoscaling_policy" "ecs_target_memory" {
  name               = "application-scaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}