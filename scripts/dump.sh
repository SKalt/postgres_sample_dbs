#!/usr/bin/env bash
### USAGE test.sh [-h|--help] [--dry-run] NAME
### test a named sample database works
### ARGS
###   -h|--help  print this message and exit
###   --dry-run  print what the test would do
###   NAME       the name of the sample database

this_dir="${BASH_SOURCE[0]%/*}"

# shellcheck source=./common.sh
. "$this_dir/common.sh"

export PGHOST="${PGHOST:-localhost}"
export PGUSER="${PGUSER:-postgres}"
export PGPORT="${PGPORT:-5432}"

is_installed() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "found $1 @ $(command -v "$1")"
  else
    return 1
  fi
}

wait_for_postgres() {
  local n="${1:-15}"
  local countdown=$((n * 2))
  while ! pg_isready; do
    if ! test $countdown -gt 0; then
      fail "pg_isready timed out after $n seconds"
    fi
    sleep .5
    countdown="$((countdown - 1))"
  done
}

load_file() {
  case "$1" in
  *.gz) gunzip -c "$1" | psql ;;
  *.sql) psql -f "$1" ;;
  *) fail "unexpected format: $1" ;;
  esac
}

main() {
  set -euo pipefail
  NAME=""
  dry_run=false
  schema_only=false
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --schema-only)
      schema_only=true
      shift
      ;;
    *)
      if test -n "$NAME"; then
        log_error "duplicate name: $1"
        usage >&2
        exit 1
      else
        NAME="$1"
        shift
      fi
      ;;
    esac
  done

  if test -z "$NAME"; then fail "missing argument: NAME"; fi
  input_dir="$repo_root/sample_dbs/$NAME"
  if ! test -d "$input_dir/"; then fail "$input_dir does not exist"; fi

  log_info "PGHOST=$PGHOST"
  log_info "PGPORT=$PGPORT"
  log_info "PGUSER=$PGUSER"

  {
    is_installed "psql"
    is_installed "pg_isready"
  } | log_debug
  if ! test "$dry_run" = "true"; then
    log_info "waiting for postgres"
    wait_for_postgres 15 | log_debug
  fi
  files=()
  if test "$schema_only" = "true"; then
    for f in "$input_dir"/sql/*.ddl.sql*; do
      files+=("$f")
    done
  else
    for f in "$input_dir"/sql/*.sql*; do
      files+=("$f")
    done
  fi
  for f in "${files[@]}"; do
    if test $dry_run = "true"; then
      log_info "would load $f"
    else
      log_info "loading $f"
      load_file "$f" 2>&1 | log_debug
    fi
  done

  schema_dump_location="$repo_root/tmp/$NAME.schema.dump.sql.gz"
  full_dump_location="$repo_root/tmp/$NAME.full.dump.sql.gz"
  if [ "$dry_run" = "true" ]; then
    if ! [ "$schema_only" = "true" ]; then
      log_info "would dump to $full_dump_location"
    fi
    log_info "would dump to $schema_dump_location"
  else
    pg_dump_args=""
    pg_dump_target=""
    if [ "$schema_only" = "true" ]; then
      log_info "dumping schema to $schema_dump_location"
      pg_dump_args="--schema-only"
      pg_dump_target="$schema_dump_location"
    else
      log_info "dumping schema + data to $schema_dump_location"
      pg_dump_target="$full_dump_location"
    fi
    {
      cat "$input_dir"/LICENSE* | sed 's/^/-- /g'
      echo "---- END LICENSE ----"
      pg_dump $pg_dump_args
    } | gzip -n -9 >"$pg_dump_target"
  fi
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
