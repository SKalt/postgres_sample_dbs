#!/usr/bin/env bash
### U
this_dir="${BASH_SOURCE[0]%/*}"
log_file=/tmp/chinook_transform.log
# shellcheck source=../common.sh
. "$this_dir/../common.sh"
source_dir="$repo_root/tmp/yugabyte-db"
target_dir="$repo_root/sample_dbs/retail_analytics"

main() {
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
    echo "# Retail Analytics"
    echo "https://docs.yugabyte.com/preview/sample-data/retail-analytics/"
  } >"$target_dir/README.md"

  log_info "copying ddl"
  cp -f "$source_dir/sample/schema.sql" "$target_dir/ddl/00_schema.sql"

  log_info "copying dml"
  cp -f "$source_dir/sample/products.sql" "$target_dir/dml/01_products.sql"
  cp -f "$source_dir/sample/users.sql" "$target_dir/dml/02_users.sql"
  cp -f "$source_dir/sample/orders.sql" "$target_dir/dml/03_orders.sql"
  cp -f "$source_dir/sample/reviews.sql" "$target_dir/dml/04_reviews.sql"

  log_info "done"
  du -hs "$target_dir"/* | log_debug
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
