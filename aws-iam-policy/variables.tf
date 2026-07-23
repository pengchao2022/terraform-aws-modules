variable "name" {
  description = "The IAM policy name"
  type        = string
}

variable "description" {
  description = "The Description of the policy"
  type        = string
  default     = null
}

variable "policy_json" {
  description = "The Json policy document"
  type        = string
}

variable "tags" {
  description = "The Tags for the policy"
  type        = map(string)
  default = {}
}

