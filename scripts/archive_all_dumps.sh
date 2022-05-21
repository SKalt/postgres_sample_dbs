#!/usr/bin/env bash
### USAGE: archive_all_dumps.sh [-h|--help] NAME
this_dir="${BASH_SOURCE[0]%/*}"

# shellcheck source=./common.sh
. "$this_dir/common.sh"

all_schema_dumps="all_schema_dumps.tar"
all_full_dumps="all_full_dumps.tar"

append_to_tar() {
  local archive_path="$1"
  local gzipped_file="$2"
  local unzipped_file="${gzipped_file%.gz}"
  if [ -f "$gzipped_file" ]; then
    log_info "appending to to $archive_path: $unzipped_file"
    rm -f "$unzipped_file" && gunzip -k "$gzipped_file" # keep the original zipped file
    tar -rf "$archive_path" "$unzipped_file"            # creates the archive if it doesn't exist
    rm "$unzipped_file"                                 # save space
  else
    log_info "no $gzipped_file; skipping"
  fi
}

main() {
  set -euo pipefail
  while [ -n "${1:-}" ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;;
    *) log_error "unexpected argument: $1" >&2 && usage >&2 && exit 1 ;;
    esac
  done

  cd "$repo_root/tmp"
  rm -f "$all_full_dumps"
  rm -f "$all_full_dumps.gz"
  rm -f "$all_schema_dumps"
  rm -f "$all_schema_dumps.gz"
  for sample_db in "$repo_root"/sample_dbs/*; do
    sample_db="${sample_db##*/}"
    append_to_tar "$all_schema_dumps" "$sample_db.schema.dump.sql.gz"
    append_to_tar "$all_full_dumps" "$sample_db.full.dump.sql.gz"
  done
  gzip -n -9 "$all_full_dumps"
  gzip -n -9 "$all_schema_dumps"
  log_info "created $repo_root/tmp/$all_full_dumps.gz"
  log_info "created $repo_root/tmp/$all_schema_dumps.gz"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
