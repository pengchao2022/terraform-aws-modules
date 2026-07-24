variable "url" {
  description = "The URL of the identity provider e.g., https://token.actions.githubusercontent.com"
  type        = string
}

variable "client_id_list" {
  description = "List of client IDs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for the provider"
  type        = map(string)
  default     = {}  
}