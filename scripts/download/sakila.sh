#!/usr/bin/env bash
### USAGE: download/sakila.sh [-h|--help]
### clone jOOQ/sakila.git to tmp/

this_dir="${BASH_SOURCE[0]%/*}"
# shellcheck source=./common.sh
. "$this_dir/common.sh"

repo_root="$(cd "$this_dir/../.." && pwd)"
remote="https://github.com/jOOQ/sakila.git"
target_dir="$repo_root/tmp/sakila"

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    *) fail "unexpected argument: $1" ;;
    esac
  done
  git clone "$remote" "$target_dir"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
