variable "target_id" {
  type        = string
  description = "The ID of the Root, OU, or Account to attach the RCP (e.g., r-9nci or an OU ID)"
}

variable "trusted_org_id" {
  type        = string
  description = "Your AWS Organization ID to define the trusted perimeter (e.g., o-15kch7po6w)"
}