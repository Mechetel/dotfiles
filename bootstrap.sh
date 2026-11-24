#!/usr/bin/env bash
# One command on a clean Mac:
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Mechetel/dotfiles/master/bootstrap.sh)"
#
# Installs the Xcode Command Line Tools (which provide git), clones the repository into
# ~/.dotfiles and runs install.sh. Arguments are passed through (e.g. --no-apps).
set -euo pipefail

REPO="${DOTFILES_REPO:-https://github.com/Mechetel/dotfiles.git}"
DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

if [ "$(uname -s)" = "Darwin" ] && ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Xcode Command Line Tools not found - starting the installer"
  xcode-select --install || true
  echo "    Wait for the installation to finish in the dialog, then press Enter..."
  read -r _ </dev/tty
fi

if [ -d "$DIR/.git" ]; then
  echo "==> $DIR already exists - updating (fast-forward only)"
  git -C "$DIR" pull --ff-only
else
  echo "==> Cloning $REPO -> $DIR"
  git clone "$REPO" "$DIR"
fi

exec "$DIR/install.sh" "$@"
