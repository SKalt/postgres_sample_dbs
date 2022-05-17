#!/usr/bin/env bash
this_dir="${BASH_SOURCE[0]%/*}"

# shellcheck source=./common.sh
. "$this_dir/common.sh"

log_info "starting fresh database"
{
  docker_compose down -v
  docker_compose up -d pg
} 2>&1 | log_debug

n=30
while ! docker_compose exec pg pg_isready &>/dev/null; do
  sleep .5
  n=$((n - 1))
  if test "$n" -lt 1; then fail "timeout"; fi
done
