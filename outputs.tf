output "redshift_serverless_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.redshift-serverless-vpc.id
}

output "redshift_serverless_vpc_cidr" {
  description = "The CIDR of the VPC"
  value       = var.redshift_serverless_vpc_cidr
}

output "redshift_serverless_iam" {
  description = "Redshift Serverless IAM"
  value       = aws_iam_role.redshift-serverless-role.arn
}

output "redshift_serverless_namespace_id" {
  description = "Redshift Serverlss Namespace ID"
  value       = aws_redshiftserverless_namespace.serverless.namespace_id
}

output "redshift_serverless_namespace_arn" {
  description = "Redshift Serverlss Namespace ID"
  value       = aws_redshiftserverless_namespace.serverless.arn
}
