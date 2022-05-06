#!/usr/bin/env bash
### USAGE: download/sakila.sh [-h|--help]
### clone jOOQ/sakila.git to tmp/

this_dir="${BASH_SOURCE[0]%/*}"
repo_root="$(cd "$this_dir/../.." && pwd)"
remote="https://github.com/jOOQ/sakila.git"
target_dir="$repo_root/tmp/sakila"
# shellcheck source=../common.sh
. "$this_dir/../common.sh"

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    *) fail "unexpected argument: $1" ;;
    esac
  done
  if test -d "$target_dir" && (cd "$target_dir" && is_git_dir); then
    (cd "$target_dir" && git pull origin main)
  else
    git clone "$remote" "$target_dir"
  fi
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
