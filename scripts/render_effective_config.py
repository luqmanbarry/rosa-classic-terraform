#!/usr/bin/env python3

import argparse
import json
from pathlib import Path
import sys

import yaml


REQUIRED_CLUSTER_KEYS = [
    "cluster_name",
    "class_name",
    "aws_region",
    "network",
    "gitops",
]


def deep_merge(base, override):
    if isinstance(base, dict) and isinstance(override, dict):
        merged = dict(base)
        for key, value in override.items():
            if key in merged:
                merged[key] = deep_merge(merged[key], value)
            else:
                merged[key] = value
        return merged
    return override


def load_yaml(path):
    with open(path, "r", encoding="utf-8") as handle:
        return yaml.safe_load(handle) or {}


def validate_cluster(cluster):
    missing = [key for key in REQUIRED_CLUSTER_KEYS if key not in cluster]
    if missing:
        raise ValueError(f"missing required cluster keys: {', '.join(missing)}")

    network = cluster.get("network", {})
    infrastructure = cluster.get("infrastructure", {})
    create_aws_resources = infrastructure.get("create_aws_resources", False)

    required_network = ["vpc_cidr_block", "base_dns_domain"]
    missing_network = [key for key in required_network if key not in network]
    if missing_network:
        raise ValueError(f"missing required network keys: {', '.join(missing_network)}")

    if create_aws_resources:
        creation_keys = ["availability_zones", "private_subnet_cidrs", "public_subnet_cidrs"]
        missing_creation = [key for key in creation_keys if key not in network]
        if missing_creation:
            raise ValueError(f"missing required network keys for AWS creation: {', '.join(missing_creation)}")
    else:
        existing_keys = ["vpc_id", "hosted_zone_id"]
        missing_existing = [key for key in existing_keys if key not in network]
        if missing_existing:
            raise ValueError(f"missing required network keys: {', '.join(missing_existing)}")

    identity = cluster.get("identity", {})
    workload_identity = identity.get("aws_workload_identity", {})
    if workload_identity.get("enabled", False):
        roles = workload_identity.get("roles", {})
        if not roles:
            raise ValueError("aws_workload_identity is enabled but no roles are defined")
        for role_name, role in roles.items():
            missing_role_keys = [key for key in ["namespace", "service_account"] if key not in role]
            if missing_role_keys:
                raise ValueError(
                    f"aws_workload_identity role {role_name} is missing keys: {', '.join(missing_role_keys)}"
                )


def main():
    parser = argparse.ArgumentParser(description="Render effective ROSA classic stack config.")
    parser.add_argument("--cluster", required=True, help="Path to cluster.yaml")
    parser.add_argument("--gitops", required=True, help="Path to gitops.yaml")
    parser.add_argument(
        "--catalog-root",
        default="catalog/cluster-classes",
        help="Path to cluster class catalog",
    )
    parser.add_argument("--output-dir", required=True, help="Directory for generated artifacts")
    args = parser.parse_args()

    cluster_path = Path(args.cluster)
    gitops_path = Path(args.gitops)
    catalog_root = Path(args.catalog_root)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    cluster = load_yaml(cluster_path)
    validate_cluster(cluster)

    class_path = catalog_root / f"{cluster['class_name']}.yaml"
    if not class_path.exists():
        raise FileNotFoundError(f"cluster class not found: {class_path}")

    cluster_class = load_yaml(class_path)
    gitops = load_yaml(gitops_path)

    effective = deep_merge(cluster_class, cluster)
    effective["gitops"] = deep_merge(effective.get("gitops", {}), gitops)
    effective["source"] = {
      "cluster_file": str(cluster_path),
      "class_file": str(class_path),
      "gitops_file": str(gitops_path),
    }

    build_metadata = {
        "cluster_name": effective["cluster_name"],
        "class_name": effective["class_name"],
        "environment": effective.get("environment"),
        "aws_region": effective.get("aws_region"),
        "openshift_version": effective.get("openshift_version"),
    }

    with open(output_dir / "effective-config.json", "w", encoding="utf-8") as handle:
        json.dump(effective, handle, indent=2, sort_keys=True)
        handle.write("\n")

    with open(output_dir / "build-metadata.json", "w", encoding="utf-8") as handle:
        json.dump(build_metadata, handle, indent=2, sort_keys=True)
        handle.write("\n")

    with open(output_dir / "terraform.auto.tfvars.json", "w", encoding="utf-8") as handle:
        json.dump({"stack": effective}, handle, indent=2, sort_keys=True)
        handle.write("\n")

    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:  # pragma: no cover
        print(f"render failed: {exc}", file=sys.stderr)
        raise
