#!/usr/bin/env bash
# Разворачивает всё окружение на чистом (или уже живом) Mac. Идемпотентен: можно
# запускать повторно после `git pull`.
#
#   ./install.sh                 # полная установка
#   ./install.sh --dry-run       # показать шаги, ничего не меняя
#   ./install.sh --no-apps       # без GUI-приложений (Brewfile.apps)
#   ./install.sh --no-brew       # без brew вообще (только линки и шелл)
#   ./install.sh --macos         # + системные настройки (scripts/macos.sh)
#   ./install.sh --help
set -euo pipefail
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts/lib.sh"

DO_BREW=1; DO_APPS=1; DO_MACOS=0; DO_VSCODE=1
for a in "$@"; do
  case "$a" in
    --dry-run)  DRY_RUN=1 ;;
    --no-brew)  DO_BREW=0 ;;
    --no-apps)  DO_APPS=0 ;;
    --no-vscode) DO_VSCODE=0 ;;
    --macos)    DO_MACOS=1 ;;
    -h|--help)  sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "неизвестный флаг: $a (см. --help)" ;;
  esac
done
export DRY_RUN

# ── 1. Homebrew ──────────────────────────────────────────────────────────────
if [ "$DO_BREW" = 1 ] && is_mac; then
  step "Homebrew"
  if ! load_brew; then
    info "brew не найден — ставлю (официальный установщик)"
    run /bin/bash -c 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    [ "$DRY_RUN" = 1 ] || load_brew || die "brew установился, но не найден в PATH"
  else
    ok "brew $(brew --prefix)"
  fi
  export HOMEBREW_NO_ANALYTICS=1

  step "Brewfile (последние версии, без закрепления)"
  # новые версии brew требуют явно доверять сторонним tap-ам — это только те, что в Brewfile
  for tap in $(sed -n 's/^tap "\([^"]*\)".*/\1/p' "$DOTFILES/Brewfile"); do
    run brew tap "$tap" 2>/dev/null || true
    run brew trust "$tap" 2>/dev/null || true
  done
  run brew bundle --file="$DOTFILES/Brewfile" || warn "часть пакетов из Brewfile не поставилась — повтори: brew bundle --file=Brewfile"

  if [ "$DO_APPS" = 1 ]; then
    step "Brewfile.apps (GUI)"
    run brew bundle --file="$DOTFILES/Brewfile.apps" || warn "часть приложений не поставилась (для mas нужен вход в App Store)"
  fi
elif ! is_mac; then
  warn "не macOS — пропускаю brew/приложения/macos"
fi

# ── 2. oh-my-zsh, плагины, p10k, tpm ─────────────────────────────────────────
"$DOTFILES/scripts/shell.sh"

# ── 2b. Шрифты, которых нет в brew ───────────────────────────────────────────
# «Fira Code Freeze» (kitty и VS Code) — свой вариант шрифта, лежит в репозитории.
if is_mac && [ -d "$DOTFILES/fonts" ]; then
  step "Шрифты из репозитория"
  run mkdir -p "$HOME/Library/Fonts"
  for f in "$DOTFILES"/fonts/*.ttf; do
    [ -e "$f" ] || continue
    if cmp -s "$f" "$HOME/Library/Fonts/$(basename "$f")"; then info "уже есть: $(basename "$f")"
    else run cp -f "$f" "$HOME/Library/Fonts/" && ok "$(basename "$f")"; fi
  done
fi

# ── 3. Симлинки ──────────────────────────────────────────────────────────────
"$DOTFILES/scripts/link.sh"

# ── 4. Локальные (непубличные, на каждую машину свои) файлы ──────────────────
step "Локальные файлы (не в репозитории)"
if [ ! -e "$HOME/.gitconfig.local" ]; then
  if [ "$DRY_RUN" != 1 ]; then
    {
      echo "# Настройки git только для этой машины. Подключается из ~/.dotfiles/gitconfig."
      if is_mac; then printf '[credential]\n\thelper = osxkeychain\n'; fi
    } > "$HOME/.gitconfig.local"
  fi
  ok "создан ~/.gitconfig.local"
else
  info "~/.gitconfig.local уже есть"
fi
if [ ! -e "$HOME/.zshrc.local" ]; then
  [ "$DRY_RUN" = 1 ] || printf '# Секреты и настройки только для этой машины (в git не попадает).\n# export BITBUCKET_LOGIN=...\n' > "$HOME/.zshrc.local"
  ok "создан ~/.zshrc.local"
else
  info "~/.zshrc.local уже есть"
fi

# ── 5. VS Code ───────────────────────────────────────────────────────────────
if [ "$DO_VSCODE" = 1 ] && have code && [ -f "$DOTFILES/vscode/extensions.txt" ]; then
  step "Расширения VS Code"
  have_ext=$(code --list-extensions 2>/dev/null | tr 'A-Z' 'a-z' || true)
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    echo "$have_ext" | grep -qx "$(echo "$ext" | tr 'A-Z' 'a-z')" || run code --install-extension "$ext" --force >/dev/null
  done < "$DOTFILES/vscode/extensions.txt"
  ok "расширения на месте"
fi

# ── 6. Neovim: плагины строго по lazy-lock.json ──────────────────────────────
if have nvim; then
  step "Neovim: плагины (по lazy-lock.json)"
  run nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1 || warn "плагины nvim: открой nvim и выполни :Lazy restore"
fi

# ── 6b. Глобальные npm-пакеты (packages/npm.txt) ─────────────────────────────
if have npm && [ -f "$DOTFILES/packages/npm.txt" ]; then
  step "Глобальные npm-пакеты"
  # shellcheck disable=SC2046
  run npm install -g $(grep -v '^#' "$DOTFILES/packages/npm.txt" | tr '\n' ' ') >/dev/null 2>&1 || warn "npm install -g не удался — повтори вручную"
fi

# ── 7. macOS defaults (по флагу) ─────────────────────────────────────────────
if [ "$DO_MACOS" = 1 ] && is_mac; then "$DOTFILES/scripts/macos.sh"; fi

step "Готово"
cat <<'EOF'
  Вручную (секреты в репозитории не хранятся):
   • перезапусти терминал (или: exec zsh) — p10k подхватит ~/.p10k.zsh
   • gh auth login; glab auth login
   • SSH-ключи и GPG-ключи — перенеси из менеджера паролей/бэкапа (~/.ssh, gpg --import)
   • Ruby: установи rvm (https://rvm.io) и нужные версии: rvm install <версия>
   • Node: nvm install --lts   (nvm подгружается лениво — первый вызов чуть медленнее)
   • Karabiner-Elements / Docker Desktop — первый запуск, выдать разрешения в Системных настройках
   • Проверка: scripts/doctor.sh
EOF
