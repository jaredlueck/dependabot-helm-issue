#!/usr/bin/env bash
set -euo pipefail

if ! command -v helm >/dev/null 2>&1; then
  echo "helm is required but not installed." >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
chart_dir="$repo_root/fixtures/demo-lib"
package_dir="$repo_root/.tmp/packages"
ghcr_owner="${GHCR_OWNER:-}"

if [[ -z "$ghcr_owner" ]]; then
  echo "Set GHCR_OWNER to your GitHub org/user, e.g. GHCR_OWNER=my-org" >&2
  exit 1
fi

ghcr_repo="oci://ghcr.io/${ghcr_owner}/helm"

if [[ -n "${GHCR_USERNAME:-}" && -n "${GHCR_TOKEN:-}" ]]; then
  echo "$GHCR_TOKEN" | helm registry login ghcr.io -u "$GHCR_USERNAME" --password-stdin >/dev/null
fi

mkdir -p "$package_dir"
rm -f "$package_dir"/*.tgz

versions=(
  "3.44.0"
  "3.44.1"
  "3.44.1-1.g585bce1"
  "3.44.1-2.g585bce1"
  "3.44.2-1.g585bce1"
  "2.0.4-qcg2060solacelabels.146.sha.7ac1266"
)

echo "Packaging and pushing demo-lib OCI tags to $ghcr_repo..."
for version in "${versions[@]}"; do
  archive="$(helm package "$chart_dir" --version "$version" --destination "$package_dir" | awk '{print $NF}')"
  helm push "$archive" "$ghcr_repo" >/dev/null
  echo "  pushed $version"
done

echo "Done."
