#!/usr/bin/env bash
### U
this_dir="${BASH_SOURCE[0]%/*}"
log_file=/tmp/retail_analytics_transform.log
# shellcheck source=../common.sh
. "$this_dir/../common.sh"
source_dir="$repo_root/tmp/yugabyte-db"
target_dir="$repo_root/sample_dbs/retail_analytics"

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    *) echo "unexpected argument: $1" >&2 && usage >&2 && exit 1 ;;
    esac
  done

  log_info "starting retail_analytics transform ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  log_info "preparing directory"
  mkdir -p "$target_dir/sql"

  log_info "copying license"
  cp -f "$source_dir/licenses/APACHE-LICENSE-2.0.txt" "$target_dir/LICENSE.txt"

  log_info "creating README"
  {
    echo "# Retail Analytics"
    echo "https://docs.yugabyte.com/preview/sample-data/retail-analytics/"
  } >"$target_dir/README.md"

  log_info "copying ddl"
  cp -f "$source_dir/sample/schema.sql" "$target_dir/sql/00_schema.ddl.sql"

  log_info "copying dml"
  cp -f "$source_dir/sample/products.sql" "$target_dir/sql/01_products.dml.sql"
  cp -f "$source_dir/sample/users.sql" "$target_dir/sql/02_users.dml.sql"
  cp -f "$source_dir/sample/orders.sql" "$target_dir/sql/03_orders.dml.sql"
  cp -f "$source_dir/sample/reviews.sql" "$target_dir/sql/04_reviews.dml.sql"

  log_info "done"
  du -hs "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
