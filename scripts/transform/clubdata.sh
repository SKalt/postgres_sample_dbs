#!/usr/bin/env bash
### U
this_dir="${BASH_SOURCE[0]%/*}"
log_file=/tmp/chinook_transform.log
# shellcheck source=../common.sh
. "$this_dir/../common.sh"
source_dir="$repo_root/tmp/yugabyte-db"
target_dir="$repo_root/sample_dbs/clubdata"

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

  log_info "creating README"
  {
    echo "# ClubData"
    echo "https://docs.yugabyte.com/preview/sample-data/pgexercises/"
  } >"$target_dir/README.md"

  log_info "copying ddl"
  cp -f "$source_dir/sample/clubdata_ddl.sql" "$target_dir/sql/00_schema.ddl.sql"

  log_info "copying dml"
  cp -f "$source_dir/sample/clubdata_data.sql" "$target_dir/sql/01_data.dml.sql"

  log_info "done"
  du -hs "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
