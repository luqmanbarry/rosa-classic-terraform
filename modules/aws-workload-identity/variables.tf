variable "enabled" {
  description = "Whether to create AWS workload identity roles for ROSA Classic service accounts."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Cluster name used in default role names and tags."
  type        = string
}

variable "oidc_endpoint_url" {
  description = "ROSA cluster OIDC issuer URL."
  type        = string
}

variable "oidc_audience" {
  description = "OIDC audience used in the AWS role trust policy."
  type        = string
  default     = "sts.amazonaws.com"
}

variable "additional_tags" {
  description = "AWS tags to apply to workload identity resources."
  type        = map(string)
  default     = {}
}

variable "roles" {
  description = "Map of workload identity roles keyed by logical name."
  type = map(object({
    namespace           = string
    service_account     = string
    role_name           = optional(string)
    description         = optional(string)
    path                = optional(string)
    managed_policy_arns = optional(list(string), [])
    inline_policy_json  = optional(string, "")
    tags                = optional(map(string), {})
  }))
  default = {}
}
