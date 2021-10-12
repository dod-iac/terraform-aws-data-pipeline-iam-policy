/**
 * ## Usage
 *
 * Creates an IAM policy for use in a data pipeline.
 *
 * ```hcl
 * module "data_pipeline_iam_policy" {
 *   source = "dod-iac/data-pipeline-iam-policy/aws"
 *
 *   name = format("app-%s-data-pipeline-%s", var.application, var.environment)
 *   s3_buckets_read  = [module.s3_bucket_source.arn]
 *   s3_buckets_write = [module.s3_bucket_destination.arn]
 *   tags = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * ## Testing
 *
 * Run all terratest tests using the `terratest` script.  If using `aws-vault`, you could use `aws-vault exec $AWS_PROFILE -- terratest`.  The `AWS_DEFAULT_REGION` environment variable is required by the tests.  Use `TT_SKIP_DESTROY=1` to not destroy the infrastructure created during the tests.  Use `TT_VERBOSE=1` to log all tests as they are run.  Use `TT_TIMEOUT` to set the timeout for the tests, with the value being in the Go format, e.g., 15m.  Use `TT_TEST_NAME` to run a specific test by name.
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to main branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "main" {

  #
  # DecryptObjects
  #

  dynamic "statement" {
    for_each = length(var.kms_keys_decrypt) > 0 ? [1] : []
    content {
      sid = "DecryptObjects"
      actions = [
        "kms:ListAliases",
        "kms:Decrypt",
      ]
      effect    = "Allow"
      resources = var.kms_keys_decrypt
    }
  }

  #
  # EncryptObjects
  #

  dynamic "statement" {
    for_each = length(var.kms_keys_encrypt) > 0 ? [1] : []
    content {
      sid = "EncryptObjects"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      effect    = "Allow"
      resources = var.kms_keys_encrypt
    }
  }

  #
  # ListBucket
  #

  dynamic "statement" {
    for_each = length(distinct(flatten([var.s3_buckets_read, var.s3_buckets_write]))) > 0 ? [1] : []
    content {
      sid = "ListBucket"
      actions = [
        "s3:GetBucketLocation",
        "s3:GetBucketRequestPayment",
        "s3:GetEncryptionConfiguration",
        "s3:ListBucket",
      ]
      effect = "Allow"
      resources = sort(distinct(flatten([
        var.s3_buckets_read,
        var.s3_buckets_write
      ])))
    }
  }

  #
  # GetObject
  #

  dynamic "statement" {
    for_each = length(var.s3_buckets_read) > 0 ? [1] : []
    content {
      sid = "GetObject"
      actions = [
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:GetObjectVersion",
      ]
      effect    = "Allow"
      resources = formatlist("%s/*", var.s3_buckets_read)
    }
  }

  #
  # ListBucketMultipartUploads
  #

  dynamic "statement" {
    for_each = length(var.s3_buckets_write) > 0 ? [1] : []
    content {
      sid = "ListBucketMultipartUploads"
      actions = [
        "s3:ListBucketMultipartUploads",
      ]
      effect    = "Allow"
      resources = var.s3_buckets_write
    }
  }

  #
  # PutObject
  #

  dynamic "statement" {
    for_each = length(var.s3_buckets_write) > 0 ? [1] : []
    content {
      sid = "PutObject"
      actions = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ]
      effect    = "Allow"
      resources = formatlist("%s/*", var.s3_buckets_write)
    }
  }

  #
  # CreatePartition
  #

  dynamic "statement" {
    for_each = length(var.glue_tables_add) > 0 ? [1] : []
    content {
      sid = "CreatePartition"
      actions = [
        "glue:BatchCreatePartition",
        "glue:CreatePartition"
      ]
      effect = "Allow"
      resources = flatten([
        formatlist(
          format(
            "arn:%s:glue:%s:%s:table/%%s",
            data.aws_partition.current.partition,
            data.aws_region.current.name,
            data.aws_caller_identity.current.account_id,
          ),
          sort([for table in var.glue_tables_add : format("%s/%s", table.database, table.table)])
        ),
        formatlist(
          format(
            "arn:%s:glue:%s:%s:database/%%s",
            data.aws_partition.current.partition,
            data.aws_region.current.name,
            data.aws_caller_identity.current.account_id,
          ),
          sort(distinct([for table in var.glue_tables_add : table.database]))
        ),
        format(
          "arn:%s:glue:%s:%s:catalog",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id,
        )
      ])
    }
  }

}

resource "aws_iam_policy" "main" {
  name        = var.name
  description = length(var.description) > 0 ? var.description : format("The policy for %s.", var.name)
  policy      = data.aws_iam_policy_document.main.json
}
