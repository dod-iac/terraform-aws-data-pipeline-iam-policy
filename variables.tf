variable "athena_buckets_source" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that store the data being queried through Athena. Use [\"*\"] to allow all buckets."
}

variable "athena_buckets_results" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that store the results of Athena queries. Use [\"*\"] to allow all buckets."
}

variable "athena_tables_exec" {
  type = list(object({
    database = string
    table    = string
  }))
  description = "A list of the Glue tables that can be read from during execution of Athena queries.  Use [\"*\"] to allow all tables."
  default     = []
}

variable "athena_workgroups_exec" {
  type        = list(string)
  description = "The ARNs of the AWS Athena workgroups that can be executed.  Use [\"*\"] to allow all workgroups."
}

variable "codecommit_repos_pull" {
  type        = list(string)
  description = "The ARNs of the AWS CodeCommit repos that can be pulled.  Use [\"*\"] to allow all repos."
  default     = []
}

variable "codecommit_repos_push" {
  type        = list(string)
  description = "The ARNs of the AWS CodeCommit repos that can be pushed.  Use [\"*\"] to allow all repos."
  default     = []
}

variable "description" {
  type        = string
  description = "The description of the AWS IAM policy.  Defaults to \"The policy for [NAME].\""
  default     = ""
}

variable "ecr_repos_read" {
  type        = list(string)
  description = "The ARNs of the AWS ECR repos that can be read from.  Use [\"*\"] to allow all repos."
  default     = []
}

variable "ecr_repos_write" {
  type        = list(string)
  description = "The ARNs of the AWS ECR repos that can be written to.  Use [\"*\"] to allow all repos."
  default     = []
}

variable "glue_tables_add" {
  type = list(object({
    database = string
    table    = string
  }))
  description = "List of Glue tables that partitions can be added to."
  default     = []
}

variable "kms_keys_decrypt" {
  type        = list(string)
  description = "The ARNs of the AWS KMS keys that can be used to decrypt data.  Use [\"*\"] to allow all keys."
  default     = []
}

variable "kms_keys_encrypt" {
  type        = list(string)
  description = "The ARNs of the AWS KMS keys that can be used to encrypt data.  Use [\"*\"] to allow all keys."
  default     = []
}

variable "name" {
  type        = string
  description = "The name of the AWS IAM policy."
}

variable "s3_buckets_write" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that can be written to.  Use [\"*\"] to allow all buckets."
  default     = []
}

variable "s3_buckets_read" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that can be read from.  Use [\"*\"] to allow all buckets."
  default     = []
}
