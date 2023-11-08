variable "user_uuid" {
  type        = string
  description = "The User UUID"
  
  validation {
    condition     = can(regex("^\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}$", var.user_uuid))
    error_message = "UserUuid must be a valid UUID format (e.g., '123e4567-e89b-12d3-a456-426655440000')."
  }
}