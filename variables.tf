variable "description" {
  type        = string
  description = "The description of the AWS IAM policy.  Defaults to \"The policy for [NAME].\""
  default     = ""
}

variable "glue_tables_add" {
  type = list(object({
    database = string
    table    = string
  }))
  description = "List of glue tables that partitions can be added to."
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
