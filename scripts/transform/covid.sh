#!/usr/bin/env bash
### U
this_dir="${BASH_SOURCE[0]%/*}"
log_file=/tmp/chinook_transform.log
# shellcheck source=../common.sh
. "$this_dir/../common.sh"
source_dir="$repo_root/tmp/yugabyte-db"
intermidiate_dir="$repo_root/tmp/unzip/covid"
target_dir="$repo_root/sample_dbs/covid"

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    *) echo "unexpected argument: $1" >&2 && usage >&2 && exit 1 ;;
    esac
  done

  log_info "preparing directories"
  mkdir -p "$target_dir/sql"
  # mkdir -p "$target_dir/workload"
  # TODO: extract workload

  log_info "copying license"
  cp -f "$source_dir/licenses/APACHE-LICENSE-2.0.txt" "$target_dir/LICENSE.txt"

  log_info "creating README"
  {
    echo "# Covid case study"
    echo "https://docs.yugabyte.com/preview/api/ysql/exprs/aggregate_functions/covid-data-case-study/"
  } >"$target_dir/README.md"

  log_info "unzipping"
  rm -rf "$intermidiate_dir"
  mkdir -p "$intermidiate_dir"
  {
    unzip -d "$intermidiate_dir" "$source_dir/sample/covid-data-case-study/covid-data-case-study.zip"
  } | log_debug

  log_info "preparing live database"
  {
    docker_compose down -v
    docker_compose up -d pg
  } 2>&1 | log_debug
  while ! docker_compose exec pg pg_isready &>/dev/null; do
    sleep 1
  done

  log_info "running database"
  {
    docker_compose exec pg sh -c '
      cd /workspace/tmp/unzip/covid
      psql --set=CHECK_FUNCTION_BODIES=off -f ./0.sql # --set=ON_ERROR_STOP=on
      '
  } | log_debug

  docker_compose exec pg pg_dump --schema-only >"$target_dir/sql/00_schema.ddl.sql"
  docker_compose exec pg pg_dump --data-only --column-inserts >"$target_dir/sql/01_data.dml.sql"

  log_info "done"
  du -hs "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
