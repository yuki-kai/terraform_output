# --------------------------------------------------
# ECS クラスター
# --------------------------------------------------
resource "aws_ecs_cluster" "ecs_cluster_output" {
  name = "ecs-cluster-output"
}

# --------------------------------------------------
# ECS タスク定義
# --------------------------------------------------
resource "aws_ecs_task_definition" "ecs_task_definition_output" {
  family                   = "terraform-output"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  // nginxのデフォルトイメージをECRから取得
  container_definitions = jsonencode([
    {
      name  = "terraform-output"
      image = "144560605492.dkr.ecr.ap-northeast-1.amazonaws.com/nextjs-app:latest",
      portMappings = [
        {
          containerPort = 3000
          "protocol"    = "tcp",
        }
      ],
    }
  ])
  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }
}

# --------------------------------------------------
# ECS サービス
# --------------------------------------------------
resource "aws_ecs_service" "ecs_service_output" {
  name            = "terraform-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster_output.id
  task_definition = aws_ecs_task_definition.ecs_task_definition_output.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_public_1a_output.id, aws_subnet.subnet_public_1c_output.id]
    security_groups  = [aws_security_group.security_group_output.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group_output.arn
    container_name   = "terraform-output" // aws_ecs_task_definitionのcontainer_definitionsのnameと同じであること
    container_port   = 3000
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy,
  ]
}
