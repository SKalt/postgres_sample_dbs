#!/usr/bin/env bash
### transform/polls.sh [-h|--help]

this_dir="${BASH_SOURCE[0]%/*}"
# shellcheck source=../common.sh
. "$this_dir/../common.sh"

source_dir="$repo_root/tmp/azure-postgresql-samples-databases"
target_dir="$repo_root/sample_dbs/polls"
ddl_dir="$target_dir/ddl"

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    *) echo "unexpected argument: $1" >&2 && usage >&2 && exit 1 ;;
    esac
  done
  log_info "preparing directory"
  mkdir -p "$target_dir/ddl"
  # mkdir -p "$target_dir/dml" # unused

  log_info "copying license"
  cp -f "$source_dir"/LICENSE* "$target_dir/"

  log_info "copying README"
  cp -f "$source_dir/polls-database-schema/readme.md" "$target_dir/README.md"

  log_info "copying ddl"
  cp -f "$source_dir/polls-database-schema/polls-schema.sql" "$ddl_dir/"

  log_info "done"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
