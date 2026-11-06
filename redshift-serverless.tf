locals {
  lf_principals = merge(
    { redshift = aws_iam_role.redshift-serverless-role.arn },
    var.knowledge_base_service_role_arn == null ? {} : {
      knowledge_base = var.knowledge_base_service_role_arn
    },
    {
      for index, principal_arn in var.additional_lake_formation_principal_arns :
      "additional_${index}" => principal_arn
    }
  )
  lf_table_grants = {
    for pair in setproduct(keys(local.lf_principals), toset(var.glue_table_names)) :
    "${pair[0]}|${pair[1]}" => {
      principal_arn = local.lf_principals[pair[0]]
      table_name    = pair[1]
    }
  }
}

resource "aws_redshiftserverless_namespace" "serverless" {
  namespace_name       = var.redshift_serverless_namespace_name
  db_name              = var.redshift_serverless_db_name
  admin_username       = var.redshift_serverless_admin_username
  admin_user_password  = var.redshift_serverless_admin_password
  iam_roles            = [aws_iam_role.redshift-serverless-role.arn]
  default_iam_role_arn = aws_iam_role.redshift-serverless-role.arn
  log_exports          = ["userlog", "connectionlog", "useractivitylog"]

  tags = {
    Name        = var.redshift_serverless_namespace_name
    Environment = var.app_environment
  }
}

resource "aws_redshiftserverless_workgroup" "serverless" {
  depends_on = [aws_redshiftserverless_namespace.serverless]

  namespace_name = aws_redshiftserverless_namespace.serverless.namespace_name
  workgroup_name = var.redshift_serverless_workgroup_name
  base_capacity  = var.redshift_serverless_base_capacity
  max_capacity   = var.redshift_serverless_max_capacity

  security_group_ids = [
    aws_security_group.redshift-serverless-security-group.id
  ]
  subnet_ids = [
    aws_subnet.redshift-serverless-subnet-az1.id,
    aws_subnet.redshift-serverless-subnet-az2.id,
  ]
  publicly_accessible = var.redshift_serverless_publicly_accessible

  tags = {
    Name        = var.redshift_serverless_workgroup_name
    Environment = var.app_environment
  }
}

resource "aws_lakeformation_permissions" "database_describe" {
  for_each = var.manage_lake_formation_permissions ? local.lf_principals : {}

  principal   = each.value
  permissions = ["DESCRIBE"]

  database {
    name       = var.glue_database_name
    catalog_id = local.catalog_account_id
  }
}

resource "aws_lakeformation_permissions" "table_select" {
  for_each = var.manage_lake_formation_permissions ? local.lf_table_grants : {}

  principal   = each.value.principal_arn
  permissions = ["SELECT"]

  table_with_columns {
    database_name = var.glue_database_name
    name          = each.value.table_name
    catalog_id    = local.catalog_account_id
    column_names  = try(var.lake_formation_column_allowlist[each.value.table_name], null)
    wildcard      = !contains(keys(var.lake_formation_column_allowlist), each.value.table_name)
  }
}
