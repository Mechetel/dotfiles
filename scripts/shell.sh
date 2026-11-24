#!/usr/bin/env bash
# Ставит то, что zshrc/tmux.conf ожидают найти на диске, но чего нет в репозитории:
# oh-my-zsh, его плагины, тему powerlevel10k и менеджер плагинов tmux (tpm).
# Клонирует через git (не curl|sh), существующее не трогает — идемпотентно.
#   scripts/shell.sh            # поставить недостающее
#   scripts/shell.sh --update   # заодно git pull уже стоящего
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

UPDATE=0; [ "${1:-}" = "--update" ] && UPDATE=1
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
CUSTOM="$ZSH_DIR/custom"

have git || die "нужен git"

clone() { # url dest
  local url="$1" dest="$2"
  if [ -d "$dest/.git" ]; then
    if [ "$UPDATE" = 1 ]; then run git -C "$dest" pull --ff-only --quiet && ok "обновлён $(basename "$dest")"; else info "уже есть: ${dest/#$HOME/~}"; fi
  else
    run mkdir -p "$(dirname "$dest")"
    run git clone --depth 1 --quiet "$url" "$dest" && ok "склонирован $(basename "$dest")"
  fi
}

step "oh-my-zsh, плагины и тема"
clone https://github.com/ohmyzsh/ohmyzsh.git                          "$ZSH_DIR"
clone https://github.com/zsh-users/zsh-autosuggestions.git            "$CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git        "$CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/zsh-users/zsh-completions.git                "$CUSTOM/plugins/zsh-completions"
clone https://github.com/romkatv/powerlevel10k.git                    "$CUSTOM/themes/powerlevel10k"

step "tmux plugin manager (tpm)"
clone https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ] && have tmux; then
  # плагины из tmux.conf ставятся без запуска tmux
  run "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || warn "tpm: плагины поставь вручную: prefix + I"
fi
