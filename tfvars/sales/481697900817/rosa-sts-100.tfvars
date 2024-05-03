#========================= BEGIN: STATIC VARIABLES ===================================

private_cluster               = false # Whether to deploy PrivateLink
tfstate_s3_bucket_name        = "rosa-sts-tfstate"
#================ ACM HUB ==============================================================
acmhub_api_server       = ""
acmhub_username         = "" # Ignore if creds pulled form Vault
acmhub_password         = "" # Ignore if creds pulled form Vault
acmhub_pull_from_vault  = true
default_kubeconfig_filename         = "/Users/luqman/.kube/config" # Use absolute path
managed_cluster_kubeconfig_filename = "/Users/luqman/.managed_cluster-kube/config"
acmhub_kubeconfig_filename          = "/Users/luqman/.acmhub-kube/config" # Use absolute path 
#================ ROSA CLUSTER =========================================================
managed_oidc                  = true
worker_node_replicas          = 3
autoscaling_enabled           = true
create_account_roles          = true
custom_ingress_domain_prefix = "shard1"
custom_ingress_name          = "shard1"
custom_ingress_machine_type  = "m5.xlarge"
custom_ingress_machine_pool_min_replicas = 3
custom_ingress_machine_pool_max_replicas = 15
ingress_sharding_tags         = [ "shard1" ]
ingress_pod_replicas          = 3 # One pod per node. Must match number of available nodes (infra or worker or both)
admin_creds_vault_generate_secret     = true
ocp_vault_secret_engine_mount         = "kv"
pod_cidr                      = "172.128.0.0/14"
service_cidr                  = "172.127.0.0/16"

proxy           = {
  enable        = false
  http_proxy    = "http://proxy.corporate.com"
  https_proxy   = "http://proxy.corporate.com"
  no_proxy      = "ec2.us-east-1.amazonaws.com,.cluster.local,ec2.internal,.ec2.internal,s3.amazonaws.com"
}
#================ VAULT SECRETS/CERTS =============================================
vault_login_path                            = "auth/approle/login"
vault_login_approle_role_id                 = "changeme"
vault_addr                                  = "https://vault.apps.rosa-7wc76.2ecu.p1.openshiftapps.com"
vault_pki_path                              = "pki"
vault_pki_ttl                               = "63070000" # should be 2 years
#================ KUBERNETES VAULT AUTH BACKEND ===================================
vault_auth_backend_kube_namespace       = "default"
vault_auth_backend_type                 = "kubernetes"
vault_auth_backend_engine_path_prefix   = "kubernetes"
vault_auth_backend_kube_sa              = "vault-token-reviewer"
vault_auth_backend_bound_sa_names       = ["*"]
vault_auth_backend_bound_sa_namespaces  = ["*"]
vault_auth_backend_token_policies       = ["dev", "stg", "prod"]
vault_auth_backend_token_ttl            = 3600
vault_auth_backend_audience             = "vault"
#================= GIT MGMT OF TFVARS ================================================
git_base_url            = "https://github.com/"
git_owner               = "luqmanbarry"
git_repository          = "rosa-sts-terraform"
git_base_branch         = "main"
git_commit_email        = "dhabbhoufaamou@gmail.com"
#========================== CICD/Bastion Network Info ==============================
ocp_sg_inbound_from_port     = 30000
ocp_sg_inbound_to_port       = 32900
cicd_instance_cidr           = "10.254.0.0/16" # IP range of whereever automation scripts are running from
cicd_sg_inbound_from_port    = 30000
cicd_sg_inbound_to_port      = 32900


#========================= END: STATIC VARIABLES =====================================

#%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN: DYNAMIC VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

business_unit="sales"

aws_account="481697900817"

vpc_name="rosa-sts-100"

vpc_id="vpc-0c0b86ddda55d4ff8"

single_nat_gateway=true

aws_region="us-east-2"

openshift_environment="dev"

cluster_name="rosa-sts-100"

cost_center="1010101010"

ocp_version="4.15.5"

acmhub_cluster_name="rosa-7wc76"

machine_type="m5.xlarge"

min_replicas=3

max_replicas=30

vpc_cidr_block="10.50.0.0/16"

private_subnet_cidrs=["10.50.1.0/24","10.50.2.0/24","10.50.3.0/24"]

private_subnet_ids=["subnet-03c23e0478e80615f","subnet-0a40266c8548e7fa3","subnet-0e31900d903e866af"]

public_subnet_cidrs=["10.50.101.0/24","10.50.102.0/24","10.50.103.0/24"]

public_subnet_ids=["subnet-017ebd6c3c6551038","subnet-042b2bed2bb0a2700","subnet-08ef3d7219423ec4f"]

availability_zones=["us-east-2a","us-east-2b","us-east-2c"]

hosted_zone_id="Z09896141XBHC2931KX7G"

base_dns_domain="non-prod.sales.example.com"

aws_additional_compute_security_group_ids=["sg-00b1995c64f0357d4"]

aws_additional_control_plane_security_group_ids=["sg-00b1995c64f0357d4"]

aws_additional_infra_security_group_ids=["sg-00b1995c64f0357d4"]

acmhub_cluster_env="dev"

admin_creds_vault_secret_name_prefix="rosa/cluster-admins/dev"

ldap_vault_secret_name="identity-providers/dev/ldap"

github_idp_vault_secret_name="identity-providers/dev/github"

gitlab_idp_vault_secret_name="identity-providers/dev/gitlab"

aad_vault_secret_name="identity-providers/dev/aad"

acmhub_vault_secret_path_prefix="acmhub/dev"

ocm_token_vault_path="sales/rosa/ocm-token"

ocm_url="https://api.openshift.com"

ocm_environment="production"

git_token_vault_path="git/github/pat"

git_ci_job_number="123"

git_ci_job_identifier="https://cicd.corporate.com/path/to/job/job-123"

git_action_taken="ROSAClusterCreate"

additional_tags={"business_unit"="sales","cost_center"="1010101010","deployer_role"="ManagedOpenShift-Installer-Role","red-hat-clustertype"="rosa","team-maintainer"="platform-ops"}

default_mp_labels={"business_unit"="sales","cost_center"="1010101010","red-hat-clustertype"="rosa","team-maintainer"="platform-ops"}

#%%%%%%%%%%%%%%%%%%%%%%%%% END: DYNAMIC VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%