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
custom_ingress_domain_prefix = "shard1"
custom_ingress_name          = "ingress-shard1"
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

business_unit="market-rd"

aws_account="842395928651"

vpc_name="rosa-class-102"

vpc_id="vpc-0e943ab7575752ef3"

single_nat_gateway=true

aws_region="us-east-1"

openshift_environment="dev"

cluster_name="rosa-class-102"

cost_center="1010101010"

ocp_version="4.15.8"

acmhub_cluster_name="noset"

machine_type="m5.xlarge"

min_replicas=3

max_replicas=30

vpc_cidr_block="10.60.0.0/16"

create_account_roles=false

private_subnet_cidrs=["10.60.1.0/24","10.60.2.0/24","10.60.3.0/24"]

private_subnet_ids=["subnet-000dd34487a256628","subnet-0a181dd1f0fe82f4d","subnet-0a33e5dd0c726b0c3"]

public_subnet_cidrs=["10.60.101.0/24","10.60.102.0/24","10.60.103.0/24"]

public_subnet_ids=["subnet-057b6b3762b41d264","subnet-0b6bbdc7ddfd50a21","subnet-0f9448a017aeb65ba"]

availability_zones=["us-east-1a","us-east-1b","us-east-1c"]

hosted_zone_id="Z04576641V4XBVKZYQL61"

base_dns_domain="non-prod.market-rd.example.com"

aws_additional_compute_security_group_ids=["sg-0fafcc696c522c31b"]

aws_additional_control_plane_security_group_ids=["sg-0fafcc696c522c31b"]

aws_additional_infra_security_group_ids=["sg-0fafcc696c522c31b"]

acmhub_cluster_env="dev"

admin_creds_vault_secret_name_prefix="rosa/cluster-admins/dev"

admin_creds_save_to_vault=false

ldap_vault_secret_name="identity-providers/dev/ldap"

github_idp_vault_secret_name="identity-providers/dev/github"

gitlab_idp_vault_secret_name="identity-providers/dev/gitlab"

aad_vault_secret_name="identity-providers/dev/aad"

acmhub_vault_secret_path_prefix="acmhub/dev"

ocm_token_vault_path="rosa/ocm-token"

ocm_url="https://api.openshift.com"

ocm_environment="production"

git_token_vault_path="git/github/pat"

git_ci_job_number="123"

git_ci_job_identifier="https://cicd.corporate.com/path/to/job/job-123"

git_action_taken="ROSAClusterCreate"

additional_tags={"business_unit"="market-rd","cost_center"="1010101010","deployer_role"="ManagedOpenShift-Installer-Role","red-hat-clustertype"="rosa","team-maintainer"="platform-ops"}

default_mp_labels={"business_unit"="market-rd","cost_center"="1010101010","red-hat-clustertype"="rosa","team-maintainer"="platform-ops"}

#%%%%%%%%%%%%%%%%%%%%%%%%% END: DYNAMIC VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%