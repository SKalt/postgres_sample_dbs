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

  log_info "waiting for live database"
  n=30
  while ! pg_isready &>/dev/null; do
    sleep .5
    n=$((n - 1))
    if test "$n" -lt 1; then fail "timeout: $(pg_isready 2>&1)"; fi
  done

  {
    psql -c "create user timchapman" || true
    psql -c "create user azuresu" || true
    psql -c "create role azure_pg_admin" || true
    psql -c "create database adventureworks with owner timchapman" || true
  } | log_debug

  log_info "transform archive-format dump to script-format dump"
  full_dump="$repo_root/tmp/adventureworks.full.dump.sql.gz"
  {
    pg_restore -U timchapman -h localhost -f - "$source_dir"/postgresql-adventureworks/AdventureWorksPG.gz
  } | gzip -n -9 >"$full_dump"

  log_info "run script-format dump, ignoring errors"
  gunzip -c "$full_dump" | psql | log_debug

  log_info "dumping schema"
  pg_dump -h localhost --schema-only |
    tee "$target_dir/sql/00_schema.ddl.sql" |
    cat "$target_dir"/LICENSE* - |
    gzip -n -9 >"$repo_root/tmp/adventureworks.schema.dump.sql.gz"

  log_info "dumping data"
  {
    pg_dump -h localhost --column-inserts --data-only
  } | gzip -n -9 >"$target_dir/sql/01_data.dml.sql.gz"

  log_info "done"
  touch -m "$target_dir/README.md" # update mtime to let `make` know that the process finished.
  du -hs "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
