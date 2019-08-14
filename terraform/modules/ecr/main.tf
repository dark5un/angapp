resource "aws_ecr_repository" "ecr" {
  name = "${var.environment}_${var.name}"

  tags = {
      Environment = var.environment
  }
}
