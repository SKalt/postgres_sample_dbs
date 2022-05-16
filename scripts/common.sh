#!/usr/bin/env bash
this_dir="${BASH_SOURCE[0]%/*}"
repo_root="$(cd "$this_dir/.." && pwd)"
log_file="${log_file:-"$repo_root/tmp/sample_db.log"}"

should_use_color() {
  test -t 1 &&                      # stdout (device 1) is a tty
    test -z "${NO_COLOR:-}" &&      # the NO_COLOR variable isn't set
    command -v tput >/dev/null 2>&1 # the `tput` command is available
}

usage() { grep '^###' "$0" | sed 's/^### //g; s/^###//g'; }

if should_use_color; then
  red="$(tput setaf 1)"
  orange="$(tput setaf 3)"
  blue="$(tput setaf 4)"
  gray="$(tput setaf 7)"
  reset="$(tput sgr0)"
else
  red=""
  orange=""
  blue=""
  gray=""
  reset=""
fi

iso_date() { date '+%Y-%m-%dT%H:%M:%S%z'; }
log_message() {
  level="$1"
  shift
  color="$1"
  shift
  message="$*"
  printf "%s\t%s\t%s\n" "$level" "$(iso_date)" "$message" |
    tee -a "$log_file" |
    sed "s/^/${color}/g; s/\t/\t${gray}/1; s/\t/${reset}\t/2;" >&2
}

log_info() { log_message "INFO" "$blue" "$*"; }
log_warning() { log_message "WARN" "$orange" "$*"; }
log_error() { log_message "ERROR" "$red" "$*"; }
log_debug() {
  color="$gray"
  cat - |
    sed "s/^/DEBUG\t$(iso_date)\t/g" |
    tee -a "$log_file" |
    sed "s/^/${color}/g; s/\t/\t${gray}/1; s/\t/${reset}\t/2;" >&2
}
fail() { log_error "$1" && exit "${2:-1}"; }

is_git_dir() { git rev-parse; }

shallow_clone() {
  git_url="$1"
  shift
  path="$1"
  shift
  trunk="$1"
  shift
  depth="${depth:-100}" # arbitrary

  mkdir -p "$path"
  cd "$path" || exit 1
  {
    git init
    git remote set-url origin "$git_url" || git remote add origin "$git_url"
    git config core.sparseCheckout true
    git sparse-checkout init
  } 2>&1 | log_debug
  log_info "initialized sparse-checkout"
  git sparse-checkout set "$@" 2>&1 | log_debug
  log_info "sparse-checkout patterns set"
  git pull --depth="$depth" origin "$trunk" 2>&1 | log_debug
}

docker_compose() {
  docker-compose "$@" # a wrapper to make handling compose v2 upgrades easier
}
