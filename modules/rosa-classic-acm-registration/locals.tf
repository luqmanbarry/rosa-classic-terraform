locals {
  cluster_name        = format("%s-%s-%s", var.business_unit, var.openshift_environment, var.cluster_name)
  klusterlet_crd_yaml = format("%s/.generated-klusterlet-crd.yaml", path.module)
  import_file_yaml    = format("%s/.generated-import.yaml", path.module)
}
