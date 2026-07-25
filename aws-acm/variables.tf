variable "domain_name" {
  description = "The main domain will be the general domain for ACM CN e.g., awsmpc.com"
  type        = string
}

variable "zone_id" {
  description = "The zone if of Route53 used for manage dns certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "A list of backup domain name SANs e.g.,api.awsmpc.com"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "The resouce tags which will be displayed on aws console first column"
  type        = map(string)
  default     = {}
}

