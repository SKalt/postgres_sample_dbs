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
  mkdir -p "$target_dir/sql"

  log_info "copying license"
  cp -f "$source_dir/licenses/APACHE-LICENSE-2.0.txt" "$target_dir/LICENSE.txt"

  log_info "creating README"
  {
    echo "# SportsDB"
    echo "https://docs.yugabyte.com/preview/sample-data/sportsdb/"
  } >"$target_dir/README.md"

  log_info "copying ddl"
  prefix="$source_dir/sample/sportsdb"
  cp -f "${prefix}_tables.sql" "$target_dir/sql/00_tables.ddl.sql"
  cp -f "${prefix}_constraints.sql" "$target_dir/sql/02_constraints.ddl.sql"
  cp -f "${prefix}_fks.sql" "$target_dir/sql/03_fks.ddl.sql"
  cp -f "${prefix}_indexes.sql" "$target_dir/sql/04_indices.ddl.sql"

  log_info "copying dml"
  # inserts need to happen before constraints are applied
  gzip -n -9 <"${prefix}_inserts.sql" >"$target_dir/sql/01_data.dml.sql.gz"

  log_info "done"
  du -hs "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
