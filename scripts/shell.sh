#!/usr/bin/env bash
# Installs what zshrc/tmux.conf expect on disk but the repository does not contain:
# oh-my-zsh, its plugins, the powerlevel10k theme and the tmux plugin manager (tpm).
# Clones with git (no curl|sh) and leaves existing checkouts alone - idempotent.
#   scripts/shell.sh            # install what is missing
#   scripts/shell.sh --update   # also `git pull` the existing checkouts
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

UPDATE=0; [ "${1:-}" = "--update" ] && UPDATE=1
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
CUSTOM="$ZSH_DIR/custom"

have git || die "git is required"

clone() { # url dest
  local url="$1" dest="$2"
  if [ -d "$dest/.git" ]; then
    if [ "$UPDATE" = 1 ]; then run git -C "$dest" pull --ff-only --quiet && ok "updated $(basename "$dest")"; else info "already present: ${dest/#$HOME/~}"; fi
  else
    run mkdir -p "$(dirname "$dest")"
    run git clone --depth 1 --quiet "$url" "$dest" && ok "cloned $(basename "$dest")"
  fi
}

step "oh-my-zsh, plugins and theme"
clone https://github.com/ohmyzsh/ohmyzsh.git                          "$ZSH_DIR"
clone https://github.com/zsh-users/zsh-autosuggestions.git            "$CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git        "$CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/zsh-users/zsh-completions.git                "$CUSTOM/plugins/zsh-completions"
clone https://github.com/romkatv/powerlevel10k.git                    "$CUSTOM/themes/powerlevel10k"

step "tmux plugin manager (tpm)"
clone https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ] && have tmux; then
  # installs the plugins listed in tmux.conf without starting tmux
  run "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || warn "tpm: install the plugins manually with prefix + I"
fi
