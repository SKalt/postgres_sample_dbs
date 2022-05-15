#!/usr/bin/env bash
this_dir="${BASH_SOURCE[0]%/*}"
log_file=/tmp/airflow_tranform.log
# shellcheck source=../common.sh
. "$this_dir/../common.sh"
source_dir="$repo_root/tmp/yugabyte-db"
target_dir="$repo_root/sample_dbs/airflow"

main() {
  set -euo pipefail

  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    *) echo "unexpected argument: $1" >&2 && usage >&2 && exit 1 ;;
    esac
  done
  log_info "preparing directory"
  mkdir -p "$target_dir/sql"

  log_info "copying license"
  cp -f "$source_dir/licenses/APACHE-LICENSE-2.0.txt" "$target_dir/LICENSE.txt"

  log_info "copying schema"
  cp -f "$source_dir/sample/airflowybrepo.sql" "$target_dir/sql/00_schema.ddl.sql"

  log_info "done"
  du -h "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
