<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

Creates an IAM policy for use in a data pipeline.

```hcl
module "data_pipeline_iam_policy" {
  source = "dod-iac/data-pipeline-iam-policy/aws"

  name = format("app-%s-data-pipeline-%s", var.application, var.environment)
  s3_buckets_read  = [module.s3_bucket_source.arn]
  s3_buckets_write = [module.s3_bucket_destination.arn]
  tags = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

## Testing

Run all terratest tests using the `terratest` script.  If using `aws-vault`, you could use `aws-vault exec $AWS_PROFILE -- terratest`.  The `AWS_DEFAULT_REGION` environment variable is required by the tests.  Use `TT_SKIP_DESTROY=1` to not destroy the infrastructure created during the tests.  Use `TT_VERBOSE=1` to log all tests as they are run.  Use `TT_TIMEOUT` to set the timeout for the tests, with the value being in the Go format, e.g., 15m.  Use `TT_TEST_NAME` to run a specific test by name.

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to main branch.

Terraform 0.11 and 0.12 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codecommit_repos_pull"></a> [codecommit\_repos\_pull](#input\_codecommit\_repos\_pull) | The ARNs of the AWS CodeCommit repos that can be pulled.  Use ["*"] to allow all repos. | `list(string)` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the AWS IAM policy.  Defaults to "The policy for [NAME]." | `string` | `""` | no |
| <a name="input_glue_tables_add"></a> [glue\_tables\_add](#input\_glue\_tables\_add) | List of glue tables that partitions can be added to. | <pre>list(object({<br>    database = string<br>    table    = string<br>  }))</pre> | `[]` | no |
| <a name="input_kms_keys_decrypt"></a> [kms\_keys\_decrypt](#input\_kms\_keys\_decrypt) | The ARNs of the AWS KMS keys that can be used to decrypt data.  Use ["*"] to allow all keys. | `list(string)` | `[]` | no |
| <a name="input_kms_keys_encrypt"></a> [kms\_keys\_encrypt](#input\_kms\_keys\_encrypt) | The ARNs of the AWS KMS keys that can be used to encrypt data.  Use ["*"] to allow all keys. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the AWS IAM policy. | `string` | n/a | yes |
| <a name="input_s3_buckets_read"></a> [s3\_buckets\_read](#input\_s3\_buckets\_read) | The ARNs of the AWS S3 buckets that can be read from.  Use ["*"] to allow all buckets. | `list(string)` | `[]` | no |
| <a name="input_s3_buckets_write"></a> [s3\_buckets\_write](#input\_s3\_buckets\_write) | The ARNs of the AWS S3 buckets that can be written to.  Use ["*"] to allow all buckets. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the AWS IAM policy. |
| <a name="output_id"></a> [id](#output\_id) | The id of the AWS IAM policy. |
| <a name="output_name"></a> [name](#output\_name) | The name of the AWS IAM policy. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
