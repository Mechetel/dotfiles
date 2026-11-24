#!/usr/bin/env bash
# Системные настройки macOS через `defaults`. НЕ запускается автоматически:
#   ./install.sh --macos     или     scripts/macos.sh
# Всё обратимо (defaults delete / настройки системы), ничего не требует sudo.
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
is_mac || die "только для macOS"

d() { run defaults write "$@"; }

step "Клавиатура"
d NSGlobalDomain KeyRepeat -int 2                     # быстрый повтор клавиш (по умолчанию 6)
d NSGlobalDomain InitialKeyRepeat -int 15             # короткая задержка до повтора (по умолчанию 25)
d NSGlobalDomain ApplePressAndHoldEnabled -bool false # повтор вместо всплывашки с акцентами (удобно для vim: hjkl)

step "Finder"
d NSGlobalDomain AppleShowAllExtensions -bool true
d com.apple.finder AppleShowAllFiles -bool true       # скрытые файлы
d com.apple.finder ShowPathbar -bool true
d com.apple.finder ShowStatusBar -bool true
d com.apple.finder FXPreferredViewStyle -string Nlsv  # список по умолчанию
d com.apple.finder _FXSortFoldersFirst -bool true
d com.apple.desktopservices DSDontWriteNetworkStores -bool true  # без .DS_Store на сетевых дисках
d com.apple.desktopservices DSDontWriteUSBStores -bool true

step "Скриншоты"
run mkdir -p "$HOME/Pictures/Screenshots"
d com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
d com.apple.screencapture disable-shadow -bool true

step "Dock"
d com.apple.dock show-recents -bool false
d com.apple.dock mru-spaces -bool false               # не переставлять Spaces сами

step "Перезапуск затронутых программ"
for app in Finder Dock SystemUIServer; do run killall "$app" >/dev/null 2>&1 || true; done
info "часть настроек (клавиатура) применится после выхода из сессии"
