#!/usr/bin/env bash
this_dir="${BASH_SOURCE[0]%/*}"
# shellcheck source=./common.sh
. "$this_dir/common.sh"

repo_root="$(cd "$this_dir/../.." && pwd)"
remote="https://github.com/Azure-Samples/postgresql-samples-databases.git"
target_dir="$repo_root/tmp/azure-postgresql-samples-databases"

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    --live) shift ;;
    *) fail "unexpected argument: $1" ;;
    esac
  done
  git clone "$remote" "$target_dir"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
