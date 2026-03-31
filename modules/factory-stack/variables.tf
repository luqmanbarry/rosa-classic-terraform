variable "stack" {
  description = "Rendered effective cluster config."
  type        = any
}

variable "ocm_token" {
  description = "OCM token for ROSA operations."
  type        = string
}

variable "vault_token" {
  description = "Vault token for optional bootstrap steps."
  type        = string
  default     = ""
}

variable "vault_login_approle_role_id" {
  type    = string
  default = ""
}

variable "vault_login_approle_secret_id" {
  type    = string
  default = ""
}

variable "vault_addr" {
  type    = string
  default = ""
}

variable "acmhub_kubeconfig_filename" {
  type    = string
  default = "~/.acmhub-kube/config"
}

variable "managed_cluster_kubeconfig_filename" {
  type    = string
  default = "~/.managed_cluster-kube/config"
}

variable "gitops_repo_username" {
  description = "Optional repository username for GitOps bootstrap."
  type        = string
  default     = ""
  sensitive   = true
}

variable "gitops_repo_password" {
  description = "Optional repository password or token for GitOps bootstrap."
  type        = string
  default     = ""
  sensitive   = true
}
