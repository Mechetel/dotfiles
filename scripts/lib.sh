#!/usr/bin/env bash
# Shared helpers for the dotfiles scripts. Source it with `. scripts/lib.sh`.
# Compatible with bash 3.2 (the system bash on macOS): no associative arrays.

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
DRY_RUN="${DRY_RUN:-0}"

if [ -t 1 ]; then
  C_RED=$'\033[31m'; C_GRN=$'\033[32m'; C_YLW=$'\033[33m'; C_BLU=$'\033[34m'; C_DIM=$'\033[2m'; C_OFF=$'\033[0m'
else
  C_RED=; C_GRN=; C_YLW=; C_BLU=; C_DIM=; C_OFF=
fi

step() { printf '\n%s==>%s %s\n' "$C_BLU" "$C_OFF" "$*"; }
info() { printf '  %s\n' "$*"; }
ok()   { printf '  %s✓%s %s\n' "$C_GRN" "$C_OFF" "$*"; }
warn() { printf '  %s!%s %s\n' "$C_YLW" "$C_OFF" "$*" >&2; }
err()  { printf '  %s✗%s %s\n' "$C_RED" "$C_OFF" "$*" >&2; }
die()  { err "$*"; exit 1; }

is_mac()  { [ "$(uname -s)" = "Darwin" ]; }
have()    { command -v "$1" >/dev/null 2>&1; }

# Run a command (or only print it when DRY_RUN=1).
run() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '  %s[dry-run]%s %s\n' "$C_DIM" "$C_OFF" "$*"
  else
    "$@"
  fi
}

# Find brew and load it into the environment of the current script (Apple Silicon / Intel / Linux).
load_brew() {
  local b
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$b" ]; then eval "$("$b" shellenv)"; return 0; fi
  done
  return 1
}
