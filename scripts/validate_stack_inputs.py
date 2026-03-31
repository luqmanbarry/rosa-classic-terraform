#!/usr/bin/env python3

import argparse
from pathlib import Path
import sys

import yaml


def load_yaml(path):
    with open(path, "r", encoding="utf-8") as handle:
        return yaml.safe_load(handle) or {}


def fail(message):
    print(f"validation failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def validate_cluster_directory(cluster_dir):
    parts = cluster_dir.parts

    if "clusters" not in parts:
        fail(f"{cluster_dir} must live under the clusters/ directory")

    clusters_index = parts.index("clusters")
    relative_parts = parts[clusters_index + 1 :]
    if len(relative_parts) < 2:
        fail(
            f"{cluster_dir} must use the layout clusters/<group>/<cluster-name>/; "
            "the group can be environment, region, business unit, or any mixed grouping"
        )

    return relative_parts


def main():
    parser = argparse.ArgumentParser(description="Validate ROSA classic factory inputs.")
    parser.add_argument("--cluster-dir", required=True, help="Path to one cluster directory")
    args = parser.parse_args()

    cluster_dir = Path(args.cluster_dir)
    relative_parts = validate_cluster_directory(cluster_dir)
    cluster_file = cluster_dir / "cluster.yaml"
    gitops_file = cluster_dir / "gitops.yaml"
    main_tf = cluster_dir / "main.tf"

    for path in [cluster_file, gitops_file, main_tf]:
        if not path.exists():
            fail(f"required file missing: {path}")

    cluster = load_yaml(cluster_file)
    gitops = load_yaml(gitops_file)

    cluster_name = cluster.get("cluster_name")
    if cluster_name and cluster_name != relative_parts[-1]:
        fail(
            f"{cluster_file} cluster_name '{cluster_name}' must match the cluster directory name "
            f"'{relative_parts[-1]}'"
        )

    for key in ["cluster_name", "class_name", "aws_region", "network", "gitops"]:
        if key not in cluster:
            fail(f"{cluster_file} is missing key: {key}")

    network = cluster.get("network", {})
    infrastructure = cluster.get("infrastructure", {})
    create_aws_resources = infrastructure.get("create_aws_resources", False)

    for key in ["vpc_cidr_block", "base_dns_domain"]:
        if key not in network:
            fail(f"{cluster_file} network is missing key: {key}")

    if create_aws_resources:
        for key in ["availability_zones", "private_subnet_cidrs", "public_subnet_cidrs"]:
            if key not in network:
                fail(f"{cluster_file} network is missing key for AWS creation: {key}")
    else:
        for key in ["vpc_id", "hosted_zone_id"]:
            if key not in network:
                fail(f"{cluster_file} network is missing key: {key}")

    if "applications" not in gitops:
        fail(f"{gitops_file} is missing key: applications")

    identity = cluster.get("identity", {})
    workload_identity = identity.get("aws_workload_identity", {})
    if workload_identity.get("enabled", False):
        roles = workload_identity.get("roles", {})
        if not roles:
            fail(f"{cluster_file} enables aws_workload_identity but defines no roles")
        for role_name, role in roles.items():
            for key in ["namespace", "service_account"]:
                if key not in role:
                    fail(f"{cluster_file} role {role_name} is missing key: {key}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
