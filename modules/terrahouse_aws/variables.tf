variable "user_uuid" {
  type = string
  description = "The User UUID"
  
  validation {
    condition = can(regex("^\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}$", var.user_uuid))
    error_message = "UserUuid must be a valid UUID format (e.g., '123e4567-e89b-12d3-a456-426655440000')."
  }
}

variable "bucket_name" {
  type = string
  description = "The name of the AWS S3 bucket"

  validation {
    condition = can(regex("^[a-zA-Z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Bucket name must consist of 3 to 63 alphanumeric characters, dots, or hyphens and must start and end with an alphanumeric character."
  }
}