#!/usr/bin/env bash
### USAGE: download/sakila.sh [-h|--help]
### clone just the `licenses` and `sample` dirs  to tmp/yugabyte-db
this_dir="${BASH_SOURCE[0]%/*}"
# shellcheck source=./common.sh
. "$this_dir/common.sh"

repo_root="$(cd "$this_dir/../.." && pwd)"
remote="https://github.com/yugabyte/yugabyte-db.git"
target_dir="$repo_root/tmp/yugabyte-db"

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    --live) shift ;;
    *) fail "unexpected argument: $1" ;;
    esac
  done
  shallow_clone "$remote" "$target_dir" "master" "sample" "licenses"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
