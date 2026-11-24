#!/usr/bin/env bash
# Раскладывает симлинки из репозитория в $HOME. Идемпотентно и безопасно:
#   * уже правильная ссылка            -> пропускается
#   * на месте лежит другой файл/ссылка -> переезжает в ~/.dotfiles-backup/<дата>/
#   * источника нет                    -> предупреждение, остальное продолжается
#
#   scripts/link.sh              # применить
#   scripts/link.sh --dry-run    # только показать, что будет сделано
#
# Добавить новый файл = одна строка в LINKS ниже: "путь-в-репо|путь-относительно-$HOME[|darwin]".
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

LINKS=(
  # shell
  "zshrc|.zshrc"
  "p10k.zsh|.p10k.zsh"
  "starship.toml|.config/starship.toml"
  # git
  "gitconfig|.gitconfig"
  "gitignore_global|.gitignore_global"
  "commitlintrc.yml|.commitlintrc.yml"
  # multiplexer / editor
  "tmux.conf|.tmux.conf"
  "nvim|.config/nvim"
  # терминал
  "kitty/kitty.conf|.config/kitty/kitty.conf"
  "kitty/dracula.conf|.config/kitty/dracula.conf"
  # файловый менеджер
  "ranger/commands.py|.config/ranger/commands.py"
  "ranger/rc.conf|.config/ranger/rc.conf"
  "ranger/scope.sh|.config/ranger/scope.sh"
  # macOS-only
  "karabiner/karabiner.json|.config/karabiner/karabiner.json|darwin"
  "vscode/settings.json|Library/Application Support/Code/User/settings.json|darwin"
  "vscode/keybindings.json|Library/Application Support/Code/User/keybindings.json|darwin"
)

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
n_ok=0; n_new=0; n_bak=0; n_skip=0

link_one() {
  local src="$DOTFILES/$1" dest="$HOME/$2" os="${3:-}"

  if [ "$os" = "darwin" ] && ! is_mac; then n_skip=$((n_skip + 1)); return; fi
  if [ ! -e "$src" ]; then warn "нет источника: $1"; n_skip=$((n_skip + 1)); return; fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    n_ok=$((n_ok + 1)); return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    run mkdir -p "$(dirname "$BACKUP_DIR/$2")"
    run mv "$dest" "$BACKUP_DIR/$2"
    info "бэкап: ~/$2 -> $BACKUP_DIR/$2"
    n_bak=$((n_bak + 1))
  fi

  run mkdir -p "$(dirname "$dest")"
  run ln -s "$src" "$dest"
  ok "~/$2 -> $1"
  n_new=$((n_new + 1))
}

mode=""; [ "$DRY_RUN" = 1 ] && mode=" [dry-run]"
step "Симлинки$mode: $DOTFILES -> $HOME"
for entry in "${LINKS[@]}"; do
  IFS='|' read -r s d o <<EOF
$entry
EOF
  link_one "$s" "$d" "${o:-}"
done
info "готово: новых $n_new, уже были $n_ok, в бэкап $n_bak, пропущено $n_skip"
