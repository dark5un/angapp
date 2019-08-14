output "front_end_listener" {
  value = aws_alb_listener.front_end
}

output "alb_target_group" {
  value = aws_alb_target_group.app
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "ecs_tasks_security_group_id" {
  value = aws_security_group.ecs_tasks.id
}
