#!/usr/bin/env bash
### transform/adventureworks.sh [-h|--help]
log_file=/tmp/adventureworks_transform.log
this_dir="${BASH_SOURCE[0]%/*}"
# shellcheck source=../common.sh
. "$this_dir/../common.sh"

repo_relative_source="tmp/azure-postgresql-samples-databases"
source_dir="$repo_root/$repo_relative_source"
target_dir="$repo_root/sample_dbs/adventureworks"

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
  cp -f "$source_dir"/LICENSE* "$target_dir/"

  # log_info "copying README"
  # cp -f "$source_dir/postgresql-adventureworks/readme.md" "$target_dir/README.md"

  # log_info "copying ddl"
  # cp -f "$source_dir/polls-database-schema/polls-schema.sql" "$ddl_dir/"

  {
    psql -c "create user timchapman" || true
    psql -c "create user azuresu" || true
    psql -c "create role azure_pg_admin" || true
    psql -c "create database adventureworks with owner timchapman" || true
  } | log_debug

  log_info "transform archive-format dump to script-format dump"
  {
    pg_restore -U timchapman -h localhost -f - "$source_dir"/postgresql-adventureworks/AdventureWorksPG.gz
  } >"$repo_root/tmp/adventureworks.dump.sql"

  log_info "run script-format dump, ignoring errors"
  psql <"$repo_root/tmp/adventureworks.dump.sql" | log_debug

  log_info "dumping schema"
  pg_dump -h localhost --schema-only >"$target_dir/sql/00_schema.ddl.sql"

  log_info "dumping data"
  {
    pg_dump -h localhost --column-inserts --data-only
  } | gzip -n -9 >"$target_dir/sql/01_data.dml.sql.gz"

  log_info "done"
  touch -m "$target_dir/README.md" # update mtime to let `make` know that the process finished.
  du -hs "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
