#!/usr/bin/env bash
# Одна команда на чистом Mac:
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Mechetel/dotfiles/master/bootstrap.sh)"
#
# Ставит Xcode Command Line Tools (даёт git), клонирует репозиторий в ~/.dotfiles
# и запускает install.sh. Аргументы пробрасываются дальше (например --no-apps).
set -euo pipefail

REPO="${DOTFILES_REPO:-https://github.com/Mechetel/dotfiles.git}"
DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

if [ "$(uname -s)" = "Darwin" ] && ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Xcode Command Line Tools не найдены — запускаю установку"
  xcode-select --install || true
  echo "    Дождись окончания установки в появившемся окне и нажми Enter…"
  read -r _ </dev/tty
fi

if [ -d "$DIR/.git" ]; then
  echo "==> $DIR уже есть — обновляю (только fast-forward)"
  git -C "$DIR" pull --ff-only
else
  echo "==> Клонирую $REPO -> $DIR"
  git clone "$REPO" "$DIR"
fi

exec "$DIR/install.sh" "$@"
