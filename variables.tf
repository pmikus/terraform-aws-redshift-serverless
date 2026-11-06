variable "app_name" {
  description = "Application name"
  type        = string
}

variable "app_environment" {
  description = "Application environment"
  type        = string
}

variable "redshift_serverless_namespace_name" {
  description = "Name of the Redshift Serverless namespace."
  type        = string
}

variable "redshift_serverless_db_name" {
  description = "Initial database created in the namespace."
  type        = string
  default     = "analytics"
}

variable "redshift_serverless_admin_username" {
  description = "Admin database username."
  type        = string
  default     = "rsadmin"
}

variable "redshift_serverless_admin_password" {
  description = "Admin Password"
  type        = string
  sensitive   = true
}

variable "redshift_serverless_workgroup_name" {
  description = "Name of the Redshift Serverless workgroup."
  type        = string
}

variable "redshift_serverless_base_capacity" {
  description = "Base Redshift Serverless capacity in RPUs. Minimum is 4."
  type        = number
  default     = 4
  validation {
    condition     = var.redshift_serverless_base_capacity >= 4 && floor(var.redshift_serverless_base_capacity) == var.redshift_serverless_base_capacity
    error_message = "redshift_serverless_base_capacity must be an integer of at least 4."
  }
}

variable "redshift_serverless_max_capacity" {
  description = "Optional maximum RPU capacity for automatic scaling. Null leaves the service default."
  type        = number
  default     = null
  nullable    = true
  validation {
    condition     = var.redshift_serverless_max_capacity == null || (var.redshift_serverless_max_capacity >= var.redshift_serverless_base_capacity && floor(var.redshift_serverless_max_capacity) == var.redshift_serverless_max_capacity)
    error_message = "redshift_serverless_max_capacity must be null or an integer greater than or equal to redshift_serverless_base_capacity."
  }
}

variable "redshift_serverless_publicly_accessible" {
  description = "Set the Redshift Serverless to be Publicly Accessible"
  type        = bool
  default     = false
}

variable "redshift_serverless_vpc_cidr" {
  description = "VPC IPv4 CIDR"
  type        = string
}

variable "redshift_serverless_subnet_1_cidr" {
  description = "IPv4 CIDR for Redshift subnet 1"
  type        = string
}

variable "redshift_serverless_subnet_2_cidr" {
  description = "IPv4 CIDR for Redshift subnet 2"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the existing bucket containing Glue-cataloged Parquet files."
  type        = string
}

variable "s3_parquet_prefixes" {
  description = "S3 key prefixes containing Parquet data, without leading/trailing slashes. Set to [\"\"] only when the Parquet data is at the bucket root."
  type        = list(string)
  default     = ["parquet"]

  validation {
    condition     = length(var.s3_parquet_prefixes) > 0
    error_message = "Provide at least one S3 Parquet prefix; use an empty string only for data at the bucket root."
  }
}

variable "glue_database_name" {
  description = "Name of the existing Glue database containing queryable tables."
  type        = string
}

variable "glue_table_names" {
  description = "Allowlisted Glue table names Redshift may query."
  type        = list(string)
  validation {
    condition     = length(var.glue_table_names) > 0
    error_message = "glue_table_names must contain at least one table."
  }
}

variable "glue_catalog_account_id" {
  description = "Account ID owning the Glue catalog; defaults to the current account."
  type        = string
  default     = null
  nullable    = true
}

variable "manage_lake_formation_permissions" {
  description = "Whether this module should grant Lake Formation read permissions to the Redshift role and additional principals."
  type        = bool
  default     = true
}

variable "additional_lake_formation_principal_arns" {
  description = "Additional IAM role ARNs, such as the Bedrock Knowledge Base service role, to grant Lake Formation read access."
  type        = list(string)
  default     = []
}

variable "knowledge_base_service_role_arn" {
  description = "Optional ARN of the existing Bedrock Knowledge Base service role. When set, the module grants it Lake Formation SELECT on the allowlisted tables; its IAM permissions must be managed elsewhere."
  type        = string
  default     = null
  nullable    = true
}

variable "lake_formation_column_allowlist" {
  description = "Optional per-table SELECT column allowlists. Tables omitted from this map receive SELECT on all columns when Lake Formation grants are enabled."
  type        = map(set(string))
  default     = {}
  validation {
    condition     = alltrue([for table_name, columns in var.lake_formation_column_allowlist : length(columns) > 0 && contains(var.glue_table_names, table_name)])
    error_message = "Column allowlists must be non-empty and may only name tables included in glue_table_names."
  }
}
