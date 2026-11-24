#!/usr/bin/env bash
# macOS system settings via `defaults`. NOT run automatically:
#   ./install.sh --macos     or     scripts/macos.sh
# Everything is reversible (defaults delete / System Settings) and needs no sudo.
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
is_mac || die "macOS only"

d() { run defaults write "$@"; }

step "Keyboard"
d NSGlobalDomain KeyRepeat -int 2                     # fast key repeat (default 6)
d NSGlobalDomain InitialKeyRepeat -int 15             # short delay before repeat (default 25)
d NSGlobalDomain ApplePressAndHoldEnabled -bool false # key repeat instead of the accent popup (handy for vim: hjkl)

step "Finder"
d NSGlobalDomain AppleShowAllExtensions -bool true
d com.apple.finder AppleShowAllFiles -bool true       # hidden files
d com.apple.finder ShowPathbar -bool true
d com.apple.finder ShowStatusBar -bool true
d com.apple.finder FXPreferredViewStyle -string Nlsv  # list view by default
d com.apple.finder _FXSortFoldersFirst -bool true
d com.apple.desktopservices DSDontWriteNetworkStores -bool true  # no .DS_Store on network volumes
d com.apple.desktopservices DSDontWriteUSBStores -bool true

step "Screenshots"
run mkdir -p "$HOME/Pictures/Screenshots"
d com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
d com.apple.screencapture disable-shadow -bool true

step "Dock"
d com.apple.dock show-recents -bool false
d com.apple.dock mru-spaces -bool false               # do not rearrange Spaces automatically

step "Restarting affected apps"
for app in Finder Dock SystemUIServer; do run killall "$app" >/dev/null 2>&1 || true; done
info "some settings (keyboard) apply after you log out and back in"
