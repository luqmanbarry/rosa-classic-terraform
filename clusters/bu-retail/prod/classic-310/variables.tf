variable "stack" {
  description = "Rendered effective stack config."
  type        = any
}

variable "ocm_token" {
  description = "OCM token for ROSA operations."
  type        = string
}

variable "vault_token" {
  type    = string
  default = ""
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
  type      = string
  default   = ""
  sensitive = true
}

variable "gitops_repo_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "gitops_repo_token" {
  type      = string
  default   = ""
  sensitive = true
}

variable "gitops_repo_token_username" {
  type      = string
  default   = "x-access-token"
  sensitive = true
}
