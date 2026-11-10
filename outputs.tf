output "redshift_serverless_role_arn" {
  description = "Redshift Serverless IAM"
  value       = aws_iam_role.redshift-serverless-role.arn
}

output "redshift_serverless_namespace_arn" {
  description = "Redshift Serverlss Namespace ARN"
  value       = aws_redshiftserverless_namespace.serverless.arn
}

output "aws_redshiftserverless_workgroup" {
  description = "Redshift Serverlss Workgroup ARN"
  value       = aws_redshiftserverless_namespace.serverless.arn
}