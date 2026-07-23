variable "repository_name" {
  description = "The name of the public ECR repository"
  type        = string
}

variable "catalog_data" {
  description = "Catalog data configuration for the public repository (description, about text, etc.)"
  type = object({
    about_text        = optional(string)
    architectures     = optional(list(string))
    description       = optional(string)
    logo_image_blob   = optional(string)
    operating_systems = optional(list(string))
    usage_text        = optional(string)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}