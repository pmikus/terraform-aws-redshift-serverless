data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

locals {
  catalog_account_id = coalesce(var.glue_catalog_account_id, data.aws_caller_identity.current.account_id)

  trimmed_s3_parquet_prefixes = [for prefix in var.s3_parquet_prefixes : trim(prefix, "/")]
  normalized_s3_parquet_prefixes = [
    for prefix in local.trimmed_s3_parquet_prefixes : prefix == "" ? "" : "${prefix}/"
  ]
  s3_parquet_object_arns = [
    for prefix in local.normalized_s3_parquet_prefixes : "${var.s3_bucket_arn}/${prefix}*"
  ]
  s3_list_prefixes = distinct(concat(
    [for prefix in local.normalized_s3_parquet_prefixes : "${prefix}*"],
    [for prefix in local.trimmed_s3_parquet_prefixes : prefix if prefix != ""]
  ))

  glue_arn_prefix   = "arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.region}:${local.catalog_account_id}"
  glue_catalog_arn  = "${local.glue_arn_prefix}:catalog"
  glue_database_arn = "${local.glue_arn_prefix}:database/${var.glue_database_name}"
  glue_table_arns = [
    for table_name in var.glue_table_names : "${local.glue_arn_prefix}:table/${var.glue_database_name}/${table_name}"
  ]
}

data "aws_iam_policy_document" "redshift-serverless-role-trust" {
  statement {
    sid     = "AllowRedshiftServerlessAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["redshift-serverless.amazonaws.com", "redshift.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_iam_role" "redshift-serverless-role" {
  name               = "${var.app_name}-${var.app_environment}-redshift-serverless-role"
  assume_role_policy = data.aws_iam_policy_document.redshift-serverless-role-trust.json

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-redshift-serverless-role"
    Environment = var.app_environment
  }
}

data "aws_iam_policy_document" "redshift-spectrum-data-read" {
  statement {
    sid       = "ListParquetPrefix"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [var.s3_bucket_arn]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = local.s3_list_prefixes
    }
  }

  statement {
    sid       = "GetBucketLocation"
    effect    = "Allow"
    actions   = ["s3:GetBucketLocation"]
    resources = [var.s3_bucket_arn]
  }

  statement {
    sid       = "ReadParquetObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = local.s3_parquet_object_arns
  }

  statement {
    sid    = "ReadGlueCatalogMetadata"
    effect = "Allow"
    actions = [
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:GetTable",
      "glue:GetTables",
      "glue:GetPartition",
      "glue:GetPartitions",
      "glue:BatchGetPartition"
    ]
    resources = concat(
      [local.glue_catalog_arn, local.glue_database_arn],
      local.glue_table_arns
    )
  }

  # Required whenever the S3 location is registered with Lake Formation,
  # regardless of whether this module manages the LF grants.
  statement {
    sid       = "LakeFormationDataAccess"
    effect    = "Allow"
    actions   = ["lakeformation:GetDataAccess"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "redshift-spectrum-data-read" {
  name   = "${var.app_name}-${var.app_environment}-redshift-spectrum-data-read"
  role   = aws_iam_role.redshift-serverless-role.id
  policy = data.aws_iam_policy_document.redshift-spectrum-data-read.json
}
