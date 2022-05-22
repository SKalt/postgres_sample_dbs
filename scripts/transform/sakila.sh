#!/usr/bin/env bash
### transform/sakila.sh [-h|--help]

this_dir="${BASH_SOURCE[0]%/*}"
log_file=/tmp/sakila_transform.log
# shellcheck source=../common.sh
. "$this_dir/../common.sh"

source_dir="$repo_root/tmp/sakila"
target_dir="$repo_root/sample_dbs/sakila"
source_ddl="$source_dir/postgres-sakila-db/postgres-sakila-schema.sql"
source_data="$source_dir/postgres-sakila-db/postgres-sakila-insert-data.sql"

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    *) fail "unexpected argument: $1" ;;
    esac
  done
  log_info "starting sakila transform ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  log_info "preparing ${target_dir//$repo_root/.}/{ddl,data}/"
  mkdir -p "$target_dir/sql"

  log_info "copying license"
  cp -f "$source_dir"/LICENSE* "$target_dir/"

  log_info "copying README"
  cp -f "$source_dir/README.md" "$target_dir"

  log_info "copying ddl"
  cp -f "$source_ddl" "$target_dir/sql/00_schema.ddl.sql"

  # due to circular foreign key constraints, we can't use pg_dump --data-only
  # to restore the table data. Using the pre-existing INSERTs is the reliable
  # way to get data into this database, but it takes ~1 minute to execute.
  log_info "copying data"
  cp -f "$source_data" "$target_dir/sql/01_data.dml.sql"
  ## here's how to create a dump of the database:
  # log_info "preparing live database"
  # docker_compose up -d pg
  # while ! docker_compose exec pg pg_isready &>/dev/null; do
  #   sleep 1
  # done

  # log_info "running ddl into which to inserting data"
  # {
  #   docker_compose exec pg sh -c 'psql -f /workspace/tmp/sakila/postgres-sakila-db/postgres-sakila-schema.sql'
  # } | log_debug

  # log_info "inserting data" # takes about a minute
  # {
  #   docker_compose exec pg sh -c 'psql -f /workspace/tmp/sakila/postgres-sakila-db/postgres-sakila-insert-data.sql'
  # } | log_debug

  log_info "done"
  du -hs "$target_dir"/* | sed "s#$repo_root#.#g" | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
