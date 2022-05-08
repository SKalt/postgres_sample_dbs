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
  mkdir -p "$target_dir/ddl"
  mkdir -p "$target_dir/dml" # unused

  log_info "copying license"
  cp -f "$source_dir"/LICENSE* "$target_dir/"

  # log_info "copying README"
  # cp -f "$source_dir/postgresql-adventureworks/readme.md" "$target_dir/README.md"

  # log_info "copying ddl"
  # cp -f "$source_dir/polls-database-schema/polls-schema.sql" "$ddl_dir/"

  log_info "preparing live database"
  {
    docker_compose down
    docker_compose up -d pg
  } 2>&1 | log_debug
  while ! docker_compose exec pg pg_isready &>/dev/null; do
    sleep 1
  done

  {
    docker_compose exec pg sh -c 'psql -c "create user timchapman"' || true
    docker_compose exec pg sh -c 'psql -c "create user azuresu"' || true
    docker_compose exec pg sh -c 'psql -c "create role azure_pg_admin"' || true
    docker_compose exec pg sh -c 'psql -c "create database adventureworks with owner timchapman"' || true
  } | log_debug

  log_info "transform archive-format dump to script-format dump"
  {
    docker_compose exec pg sh -c "pg_restore -U timchapman -h localhost  -f - /workspace/$repo_relative_source/postgresql-adventureworks/AdventureWorksPG.gz"
  } >"$repo_root/tmp/adventureworks.dump.sql"

  log_info "run script-format dump, ignoring errors"
  {
    docker_compose exec pg sh -c 'cat /workspace/tmp/adventureworks.dump.sql | psql'
  } | log_debug

  log_info "dumping schema"
  {
    docker_compose exec pg sh -c 'pg_dump -h localhost --schema-only'
  } >"$target_dir/ddl/00_schema.sql"

  log_info "dumping data"
  {
    docker_compose exec pg sh -c 'pg_dump -h localhost --column-inserts --data-only'
  } | gzip -9 >"$target_dir/dml/01_data.sql.gz"

  log_info "done"
  touch -m "$target_dir/README.md" # update mtime to let `make` know that the process finished.
  du -hs "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
