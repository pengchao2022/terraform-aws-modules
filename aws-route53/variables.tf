variable "domain_name" {
  description = "The name of domain e.g., awsmpc.com"
  type        = string
}

variable "records" {
  description = "A list of DNS records used to create A, Alias, CNAME etc."
  type = list(object({
    name           = string
    type           = string
    ttl            = optional(number)
    records        = optional(list(string)) # IP addr list when not using Alias
    routing_policy = optional(string, "simple") # routing policy like, simple, weighted, latency, failover etc,
    weight         = optional(number)      # when routing policy is weighted
    set_identifier = optional(string)      # when weighted or failover
    
    # alias will be used for aws alb , cloudfront etc,
    alias          = optional(object({
      name                   = string     # target resource dns name
      zone_id                = string     # zone_id
      evaluate_target_health  = bool      # turn on target health check or not
    }))
  }))  
  default = []
}

variable "tags" {
  description = "The resource tags which will be displayed on aws console first column"
  type        = map(string)
  default = {}
}