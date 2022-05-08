#!/usr/bin/env bash
### U
this_dir="${BASH_SOURCE[0]%/*}"
log_file=/tmp/chinook_transform.log
# shellcheck source=../common.sh
. "$this_dir/../common.sh"
source_dir="$repo_root/tmp/yugabyte-db"
target_dir="$repo_root/sample_dbs/sportsdb"

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
  mkdir -p "$target_dir/dml"

  log_info "copying license"
  cp -f "$source_dir/licenses/APACHE-LICENSE-2.0.txt" "$target_dir/LICENSE.txt"

  log_info "creating README"
  {
    echo "# SportsDB"
    echo "https://docs.yugabyte.com/preview/sample-data/sportsdb/"
  } >"$target_dir/README.md"

  log_info "copying ddl"
  cp -f "$source_dir/sample/sportsdb_tables.sql" "$target_dir/ddl/00_tables.sql"
  cp -f "$source_dir/sample/sportsdb_constraints.sql" "$target_dir/ddl/02_constraints.sql"
  cp -f "$source_dir/sample/sportsdb_fks.sql" "$target_dir/ddl/03_fks.sql"
  cp -f "$source_dir/sample/sportsdb_indexes.sql" "$target_dir/ddl/04_indices.sql"

  log_info "copying dml"
  # inserts need to happen before constraints are applied
  cp -f "$source_dir/sample/clubdata_data.sql" "$target_dir/dml/01_data.sql"

  log_info "done"
  du -hs "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
