#========================= BEGIN: STATIC VARIABLES ===================================

private_cluster               = false # Whether to deploy PrivateLink
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
autoscaling_enabled           = true
custom_ingress_domain_prefix = "ingress1"
custom_ingress_name          = "ingress1"
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

business_unit="engineering"

aws_account="099964036147"

vpc_name="classic-acm-hub"

vpc_id="vpc-0e51ab2ff7cb77bca"

single_nat_gateway=true

aws_region="us-east-2"

openshift_environment="dev"

cluster_name="classic-acm-hub"

cost_center="1010101010"

ocp_version="4.15.12"

acmhub_cluster_name="rosa-acm-hub"

machine_type="m5.2xlarge"

worker_node_replicas=3

min_replicas=6

max_replicas=30

tfstate_s3_bucket_name="rosa-classic-acm-demo-luqman"

vpc_cidr_block="10.91.0.0/16"

create_account_roles=true

private_subnet_cidrs=["10.50.1.0/24","10.50.2.0/24","10.50.3.0/24"]

private_subnet_ids=["subnet-06bb79a30ea70ce9f","subnet-0b8e2249b41a4375c","subnet-0cd6860c9ea02560b"]

public_subnet_cidrs=["10.50.101.0/24","10.50.102.0/24","10.50.103.0/24"]

public_subnet_ids=["subnet-02410afdbb5fd4543","subnet-0b1b2c48d05d27e72","subnet-0f5d57cec09d1660a"]

availability_zones=["us-east-2a","us-east-2b","us-east-2c"]

hosted_zone_id="Z0938555SBQ425NCYE3H"

base_dns_domain="non-prod.engineering.example.com"

vault_addr="https://vault.apps.classic-acm-hub.dlhq.p1.openshiftapps.com"

aws_additional_compute_security_group_ids=["sg-04fea143bf8050db5"]

aws_additional_control_plane_security_group_ids=["sg-04fea143bf8050db5"]

aws_additional_infra_security_group_ids=["sg-04fea143bf8050db5"]

acmhub_cluster_env="dev"

admin_creds_vault_secret_name_prefix="rosa/cluster-admins/dev"

admin_creds_save_to_vault=true

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

additional_tags={"business_unit"="engineering","cost_center"="1010101010","deployer_role"="ManagedOpenShift-Installer-Role","red-hat-clustertype"="rosa","team-maintainer"="platform-ops"}

default_mp_labels={"business_unit"="engineering","cost_center"="1010101010","red-hat-clustertype"="rosa","team-maintainer"="platform-ops"}

#%%%%%%%%%%%%%%%%%%%%%%%%% END: DYNAMIC VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%