#!/usr/bin/env bash
set -euo pipefail

base_ref="${1:-origin/main}"

git diff --name-only "${base_ref}"...HEAD \
  | rg '^clusters/.+/' \
  | while IFS= read -r changed_path; do
      cluster_dir="$(dirname "$changed_path")"
      while [[ "$cluster_dir" != "clusters" && ! -f "$cluster_dir/cluster.yaml" ]]; do
        cluster_dir="$(dirname "$cluster_dir")"
      done

      if [[ -f "$cluster_dir/cluster.yaml" ]]; then
        echo "$cluster_dir"
      fi
    done \
  | sort -u
