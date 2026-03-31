variable "enabled" {
  description = "Whether to bootstrap OpenShift GitOps."
  type        = bool
  default     = false
}

variable "managed_cluster_kubeconfig_filename" {
  type        = string
  description = "Kubeconfig path for the managed cluster."
}

variable "cluster_name" {
  type        = string
  description = "Managed cluster name."
}

variable "gitops_operator_namespace" {
  type        = string
  description = "Namespace where the operator subscription is created."
  default     = "openshift-gitops-operator"
}

variable "gitops_namespace" {
  type        = string
  description = "Namespace for the Argo CD instance."
  default     = "openshift-gitops"
}

variable "gitops_channel" {
  type        = string
  description = "Operator channel."
  default     = "gitops-1.15"
}

variable "gitops_git_repo_url" {
  type        = string
  description = "Git repository URL for the root application."
  default     = ""
}

variable "gitops_target_revision" {
  type        = string
  description = "Git target revision for the root application."
  default     = "main"
}

variable "gitops_root_app_path" {
  type        = string
  description = "Path to the root app or overlay in the GitOps repository."
  default     = "gitops/overlays/cluster-applications"
}

variable "gitops_values" {
  type        = any
  description = "Values object injected into the root app chart."
  default     = {}
}

variable "gitops_repo_username" {
  type        = string
  description = "Optional repository username for legacy basic-auth bootstrap."
  default     = ""
  sensitive   = true

  validation {
    condition = (
      trimspace(var.gitops_repo_username) == "" ||
      trimspace(var.gitops_repo_token) == ""
    )
    error_message = "Set either gitops_repo_token or gitops_repo_username, not both."
  }
}

variable "gitops_repo_password" {
  type        = string
  description = "Optional repository password for legacy basic-auth bootstrap."
  default     = ""
  sensitive   = true

  validation {
    condition = (
      trimspace(var.gitops_repo_password) == "" ||
      trimspace(var.gitops_repo_token) == ""
    )
    error_message = "Set either gitops_repo_token or gitops_repo_password, not both."
  }

  validation {
    condition = (
      (trimspace(var.gitops_repo_username) == "" && trimspace(var.gitops_repo_password) == "") ||
      (trimspace(var.gitops_repo_username) != "" && trimspace(var.gitops_repo_password) != "")
    )
    error_message = "Legacy basic-auth bootstrap requires both gitops_repo_username and gitops_repo_password, or neither."
  }
}

variable "gitops_repo_token" {
  type        = string
  description = "Optional Git access token for bootstrap. Prefer a short-lived GitHub App installation token or PAT over legacy basic auth."
  default     = ""
  sensitive   = true

  validation {
    condition = (
      trimspace(var.gitops_repo_token) == "" ||
      (trimspace(var.gitops_repo_username) == "" && trimspace(var.gitops_repo_password) == "")
    )
    error_message = "When gitops_repo_token is set, leave gitops_repo_username and gitops_repo_password empty."
  }
}

variable "gitops_repo_token_username" {
  type        = string
  description = "Username to pair with gitops_repo_token when the Git provider expects one. Use x-access-token for GitHub."
  default     = ""
  sensitive   = true
}
