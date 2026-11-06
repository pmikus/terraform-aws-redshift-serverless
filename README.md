<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.41.0, < 7.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.41.0, < 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_iam_role.redshift-serverless-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.redshift-spectrum-data-read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lakeformation_permissions.database_describe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_permissions.table_select](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_permissions) | resource |
| [aws_redshiftserverless_namespace.serverless](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_namespace) | resource |
| [aws_redshiftserverless_workgroup.serverless](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_workgroup) | resource |
| [aws_security_group.redshift-serverless-security-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.redshift-serverless-subnet-az1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.redshift-serverless-subnet-az2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.redshift-serverless-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.redshift-serverless-role-trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.redshift-spectrum-data-read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_additional_lake_formation_principal_arns"></a> [additional\_lake\_formation\_principal\_arns](#input\_additional\_lake\_formation\_principal\_arns) | Additional IAM role ARNs, such as the Bedrock Knowledge Base service role, to grant Lake Formation read access. | `list(string)` | `[]` | no |
| <a name="input_app_environment"></a> [app\_environment](#input\_app\_environment) | Application environment | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name | `string` | n/a | yes |
| <a name="input_glue_catalog_account_id"></a> [glue\_catalog\_account\_id](#input\_glue\_catalog\_account\_id) | Account ID owning the Glue catalog; defaults to the current account. | `string` | `null` | no |
| <a name="input_glue_database_name"></a> [glue\_database\_name](#input\_glue\_database\_name) | Name of the existing Glue database containing queryable tables. | `string` | n/a | yes |
| <a name="input_glue_table_names"></a> [glue\_table\_names](#input\_glue\_table\_names) | Allowlisted Glue table names Redshift may query. | `list(string)` | n/a | yes |
| <a name="input_knowledge_base_service_role_arn"></a> [knowledge\_base\_service\_role\_arn](#input\_knowledge\_base\_service\_role\_arn) | Optional ARN of the existing Bedrock Knowledge Base service role. When set, the module grants it Lake Formation SELECT on the allowlisted tables; its IAM permissions must be managed elsewhere. | `string` | `null` | no |
| <a name="input_lake_formation_column_allowlist"></a> [lake\_formation\_column\_allowlist](#input\_lake\_formation\_column\_allowlist) | Optional per-table SELECT column allowlists. Tables omitted from this map receive SELECT on all columns when Lake Formation grants are enabled. | `map(set(string))` | `{}` | no |
| <a name="input_manage_lake_formation_permissions"></a> [manage\_lake\_formation\_permissions](#input\_manage\_lake\_formation\_permissions) | Whether this module should grant Lake Formation read permissions to the Redshift role and additional principals. | `bool` | `true` | no |
| <a name="input_redshift_serverless_admin_password"></a> [redshift\_serverless\_admin\_password](#input\_redshift\_serverless\_admin\_password) | Admin Password | `string` | n/a | yes |
| <a name="input_redshift_serverless_admin_username"></a> [redshift\_serverless\_admin\_username](#input\_redshift\_serverless\_admin\_username) | Admin database username. | `string` | `"rsadmin"` | no |
| <a name="input_redshift_serverless_base_capacity"></a> [redshift\_serverless\_base\_capacity](#input\_redshift\_serverless\_base\_capacity) | Base Redshift Serverless capacity in RPUs. Minimum is 4. | `number` | `4` | no |
| <a name="input_redshift_serverless_db_name"></a> [redshift\_serverless\_db\_name](#input\_redshift\_serverless\_db\_name) | Initial database created in the namespace. | `string` | `"analytics"` | no |
| <a name="input_redshift_serverless_max_capacity"></a> [redshift\_serverless\_max\_capacity](#input\_redshift\_serverless\_max\_capacity) | Optional maximum RPU capacity for automatic scaling. Null leaves the service default. | `number` | `null` | no |
| <a name="input_redshift_serverless_namespace_name"></a> [redshift\_serverless\_namespace\_name](#input\_redshift\_serverless\_namespace\_name) | Name of the Redshift Serverless namespace. | `string` | n/a | yes |
| <a name="input_redshift_serverless_publicly_accessible"></a> [redshift\_serverless\_publicly\_accessible](#input\_redshift\_serverless\_publicly\_accessible) | Set the Redshift Serverless to be Publicly Accessible | `bool` | `false` | no |
| <a name="input_redshift_serverless_subnet_1_cidr"></a> [redshift\_serverless\_subnet\_1\_cidr](#input\_redshift\_serverless\_subnet\_1\_cidr) | IPv4 CIDR for Redshift subnet 1 | `string` | n/a | yes |
| <a name="input_redshift_serverless_subnet_2_cidr"></a> [redshift\_serverless\_subnet\_2\_cidr](#input\_redshift\_serverless\_subnet\_2\_cidr) | IPv4 CIDR for Redshift subnet 2 | `string` | n/a | yes |
| <a name="input_redshift_serverless_vpc_cidr"></a> [redshift\_serverless\_vpc\_cidr](#input\_redshift\_serverless\_vpc\_cidr) | VPC IPv4 CIDR | `string` | n/a | yes |
| <a name="input_redshift_serverless_workgroup_name"></a> [redshift\_serverless\_workgroup\_name](#input\_redshift\_serverless\_workgroup\_name) | Name of the Redshift Serverless workgroup. | `string` | n/a | yes |
| <a name="input_s3_bucket_arn"></a> [s3\_bucket\_arn](#input\_s3\_bucket\_arn) | ARN of the existing bucket containing Glue-cataloged Parquet files. | `string` | n/a | yes |
| <a name="input_s3_parquet_prefixes"></a> [s3\_parquet\_prefixes](#input\_s3\_parquet\_prefixes) | S3 key prefixes containing Parquet data, without leading/trailing slashes. Set to [""] only when the Parquet data is at the bucket root. | `list(string)` | <pre>[<br/>  "parquet"<br/>]</pre> | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_redshift_serverless_iam"></a> [redshift\_serverless\_iam](#output\_redshift\_serverless\_iam) | Redshift Serverless IAM |
| <a name="output_redshift_serverless_namespace_arn"></a> [redshift\_serverless\_namespace\_arn](#output\_redshift\_serverless\_namespace\_arn) | Redshift Serverlss Namespace ID |
| <a name="output_redshift_serverless_namespace_id"></a> [redshift\_serverless\_namespace\_id](#output\_redshift\_serverless\_namespace\_id) | Redshift Serverlss Namespace ID |
| <a name="output_redshift_serverless_vpc_cidr"></a> [redshift\_serverless\_vpc\_cidr](#output\_redshift\_serverless\_vpc\_cidr) | The CIDR of the VPC |
| <a name="output_redshift_serverless_vpc_id"></a> [redshift\_serverless\_vpc\_id](#output\_redshift\_serverless\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->