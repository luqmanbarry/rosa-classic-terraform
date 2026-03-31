#!/usr/bin/env bash
set -euo pipefail

base_ref="${1:-origin/main}"

git diff --name-only "${base_ref}"...HEAD \
  | rg '^clusters/[^/]+/[^/]+/' \
  | awk -F/ '{print $1 "/" $2 "/" $3}' \
  | sort -u
