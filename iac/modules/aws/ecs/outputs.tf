output "service_task_roles" {
  description = "Map of service names to their task role ARNs"
  value = {
    for svc_name in keys(var.services) : svc_name => aws_iam_role.task_role.arn
  }
}
