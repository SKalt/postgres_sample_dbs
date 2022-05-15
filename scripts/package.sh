#!/usr/bin/env bash
### USAGE: package.sh [-h|--help] [--dry-run] NAME
### ARGS
###   -h|--help   print this message and exit
###   --dry-run   print what would be packaged without packaging it
###   NAME        of the sample database

this_dir="${BASH_SOURCE[0]%/*}"

# shellcheck source=./common.sh
. "$this_dir/common.sh"

package() {
  local input_dir="$1"
  local output_file="$2"
  (cd "$input_dir" && tar -zcf "$output_file" .)
}

main() {
  dry_run=false
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    *)
      if test -z "${NAME:-}"; then
        NAME=$1
        shift
      else
        log_error "unexpeted duplicate name: $1"
        usage >&2
        exit 1
      fi
      ;;
    esac
  done
  if test -z "${NAME:-}"; then
    log_error "missing NAME"
    usage >&2
    exit 1
  fi

  input_dir="$repo_root/sample_dbs/$NAME"
  schema_only="$repo_root/tmp/$NAME.schema_only.tar.gz"
  ensemble="$repo_root/tmp/$NAME.full.tar.gz"
  if ! test -e "$input_dir"; then fail "$input_dir does not exist"; fi

  cmd="
    (cd $input_dir && tar -cf $schema_only -z ./LICENSE* ./README* ./ddl/);
    (cd $input_dir && tar -cf $ensemble -z ./LICENSE* ./README* ./ddl/ ./dml/);
  "

  if test "$dry_run" = "true"; then
    log_info "would run:"
    echo "$cmd" | log_debug
  else
    eval "$cmd"
  fi
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
