terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.7"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

locals {
  openshift_gitops_chart_dir = "${path.module}/../../gitops/bootstrap/openshift-gitops"
  root_app_chart_dir         = "${path.module}/../../gitops/bootstrap/root-app"
  operator_values_file       = "${path.module}/.tmp-${var.cluster_name}-openshift-gitops-values.yaml"
  root_app_values_file       = "${path.module}/.tmp-${var.cluster_name}-root-app-values.yaml"
}

resource "local_file" "operator_values" {
  count = var.enabled ? 1 : 0

  content = yamlencode({
    gitopsOperatorNamespace = var.gitops_operator_namespace
    gitopsNamespace         = var.gitops_namespace
    gitopsChannel           = var.gitops_channel
  })
  filename = local.operator_values_file
}

resource "local_file" "root_app_values" {
  count = var.enabled ? 1 : 0

  content = yamlencode({
    rootApplication = {
      name                 = "${var.cluster_name}-root"
      namespace            = var.gitops_namespace
      destinationNamespace = var.gitops_namespace
      project              = "default"
      path                 = var.gitops_root_app_path
    }
    git = {
      repoURL        = var.gitops_git_repo_url
      targetRevision = var.gitops_target_revision
      username       = var.gitops_repo_username
      password       = var.gitops_repo_password
    }
    bootstrapValues = merge(
      var.gitops_values,
      {
        clusterName     = var.cluster_name
        gitopsNamespace = var.gitops_namespace
        git = {
          repoURL        = var.gitops_git_repo_url
          targetRevision = var.gitops_target_revision
        }
        projects = try(var.gitops_values.projects, [
          {
            name        = "platform"
            namespace   = var.gitops_namespace
            description = "Platform applications managed by the cluster factory."
            sourceRepos = try(var.gitops_values.projectSourceRepos, ["*"])
          },
          {
            name        = "workloads"
            namespace   = var.gitops_namespace
            description = "Workload applications managed by the cluster factory."
            sourceRepos = try(var.gitops_values.projectSourceRepos, ["*"])
          },
        ])
        applications = try(var.gitops_values.applications, [])
      }
    )
  })
  filename = local.root_app_values_file
}

resource "null_resource" "deploy_operator" {
  count = var.enabled ? 1 : 0

  depends_on = [local_file.operator_values]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -euo pipefail
      helm template openshift-gitops-operator "$CHART_DIR" --values "$VALUES_FILE" | oc --kubeconfig="$KUBECONFIG" apply -f -
    EOT
    environment = {
      CHART_DIR   = local.openshift_gitops_chart_dir
      KUBECONFIG  = var.managed_cluster_kubeconfig_filename
      VALUES_FILE = local.operator_values_file
    }
  }

  triggers = {
    cluster_name              = var.cluster_name
    gitops_namespace          = var.gitops_namespace
    gitops_operator_namespace = var.gitops_operator_namespace
    gitops_channel            = var.gitops_channel
  }
}

resource "null_resource" "wait_for_operator_ready" {
  count      = var.enabled ? 1 : 0
  depends_on = [null_resource.deploy_operator]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -euo pipefail
      oc --kubeconfig="$KUBECONFIG" wait --for=condition=AtLatestKnown subscription/openshift-gitops-operator -n "$OPERATOR_NAMESPACE" --timeout=10m
      oc --kubeconfig="$KUBECONFIG" wait --for=condition=Available deployment/gitops-operator-controller-manager -n "$OPERATOR_NAMESPACE" --timeout=10m
      oc --kubeconfig="$KUBECONFIG" wait --for=condition=Available deployment/openshift-gitops-server -n "$GITOPS_NAMESPACE" --timeout=10m
      oc --kubeconfig="$KUBECONFIG" wait --for=condition=Available deployment/openshift-gitops-repo-server -n "$GITOPS_NAMESPACE" --timeout=10m
    EOT
    environment = {
      KUBECONFIG         = var.managed_cluster_kubeconfig_filename
      OPERATOR_NAMESPACE = var.gitops_operator_namespace
      GITOPS_NAMESPACE   = var.gitops_namespace
    }
  }

  triggers = {
    cluster_name              = var.cluster_name
    gitops_namespace          = var.gitops_namespace
    gitops_operator_namespace = var.gitops_operator_namespace
  }
}

resource "null_resource" "deploy_root_app" {
  count      = var.enabled ? 1 : 0
  depends_on = [null_resource.wait_for_operator_ready, local_file.root_app_values]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -euo pipefail
      helm template rosa-root-app "$CHART_DIR" --values "$VALUES_FILE" | oc --kubeconfig="$KUBECONFIG" apply -f -
    EOT
    environment = {
      CHART_DIR   = local.root_app_chart_dir
      KUBECONFIG  = var.managed_cluster_kubeconfig_filename
      VALUES_FILE = local.root_app_values_file
    }
  }

  triggers = {
    cluster_name    = var.cluster_name
    repo_url        = var.gitops_git_repo_url
    target_revision = var.gitops_target_revision
    root_app_path   = var.gitops_root_app_path
  }
}
