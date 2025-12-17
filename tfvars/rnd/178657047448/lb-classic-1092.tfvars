#========================= BEGIN: STATIC VARIABLES ===================================

private_cluster               = false # Whether to deploy PrivateLink
#================ ACM HUB ==============================================================
acmhub_api_server       = ""
acmhub_username         = "" # Ignore if creds pulled form Vault
acmhub_password         = "" # Ignore if creds pulled form Vault
acmhub_pull_from_vault  = true
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

business_unit="rnd"

aws_account="178657047448"

vpc_name="lb-classic-1092"

vpc_id="vpc-0eef07c62615d0b58"

single_nat_gateway=true

aws_region="us-east-2"

openshift_environment="dev"

cluster_name="lb-classic-1092"

cost_center="1010101010"

ocp_version="4.15.14"

acmhub_cluster_name="classic-acm-hub"

default_kubeconfig_filename="/Users/luqman/.kube/config"

managed_cluster_kubeconfig_filename="/Users/luqman/.managed_cluster_kube/config"

acmhub_kubeconfig_filename="/Users/luqman/.acmhub_kube/config"

machine_type="m5.xlarge"

worker_node_replicas=3

min_replicas=6

max_replicas=30

tfstate_s3_bucket_name="rosa-classic-tfstate"

vpc_cidr_block="10.92.0.0/16"

create_account_roles=true

private_subnet_cidrs=["10.50.1.0/24","10.50.2.0/24","10.50.3.0/24"]

private_subnet_ids=["subnet-057a6fb1da9c78060","subnet-08b9646c985da0306","subnet-0a08e3e2ada68179e"]

public_subnet_cidrs=["10.50.101.0/24","10.50.102.0/24","10.50.103.0/24"]

public_subnet_ids=["subnet-036e99db92aece57b","subnet-0c30430c42ef2729e","subnet-0ec9aaa4bab5533f9"]

availability_zones=["us-east-2a","us-east-2b","us-east-2c"]

hosted_zone_id="Z06221343SGOF52SWEC1L"

base_dns_domain="non-prod.rnd.example.com"

vault_addr="https://vault.apps.classic-acm-hub.dlhq.p1.openshiftapps.com"

aws_additional_compute_security_group_ids=["sg-0d7d01dc4d4179874"]

aws_additional_control_plane_security_group_ids=["sg-0d7d01dc4d4179874"]

aws_additional_infra_security_group_ids=["sg-0d7d01dc4d4179874"]

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

additional_tags={"business_unit"="rnd","cost_center"="1010101010","deployer_role"="ManagedOpenShift-Installer-Role","red-hat-clustertype"="rosa","team-maintainer"="platform-ops"}

default_mp_labels={"business_unit"="rnd","cost_center"="1010101010","red-hat-clustertype"="rosa","team-maintainer"="platform-ops"}

#%%%%%%%%%%%%%%%%%%%%%%%%% END: DYNAMIC VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%