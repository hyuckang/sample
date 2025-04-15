# https://registry.terraform.io/modules/terraform-aws-modules/ecr/aws/latest
module "springboot-ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.1"

  repository_name                   = "${var.project_name}-springboot"
  repository_read_write_access_arns = [var.cluster_admin_role, var.cluster_developer_role]

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

}