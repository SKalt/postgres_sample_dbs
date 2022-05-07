#!/usr/bin/env bash
this_dir="${BASH_SOURCE[0]%/*}"
repo_root="$(cd "$this_dir/../.." && pwd)"
remote="https://github.com/Azure-Samples/postgresql-samples-databases.git"
target_dir="$repo_root/tmp/azure-postgresql-samples-databases"
log_file="/tmp/azure_pg_sample_dbs_lownload.log"
# shellcheck source=../common.sh
. "$this_dir/../common.sh"

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    --live) shift ;;
    *) fail "unexpected argument: $1" ;;
    esac
  done

  if test -d "$target_dir" && (cd "$target_dir" && is_git_dir); then
    log_info "pulling $remote"
    (cd "$target_dir" && git pull origin main) 2>&1 | log_debug
  else
    log_info "cloning $remote"
    git clone "$remote" "$target_dir" 2>&1 | log_debug
  fi
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
