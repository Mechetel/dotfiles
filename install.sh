#!/usr/bin/env bash
# Sets up the whole environment on a fresh (or already used) Mac. Idempotent: safe to
# run again after `git pull`.
#
#   ./install.sh                 # full install
#   ./install.sh --dry-run       # show the steps without changing anything
#   ./install.sh --no-apps       # skip GUI applications (Brewfile.apps)
#   ./install.sh --no-brew       # skip brew entirely (links and shell only)
#   ./install.sh --no-vscode     # skip VS Code extensions
#   ./install.sh --macos         # also apply macOS defaults (scripts/macos.sh)
#   ./install.sh --help
set -euo pipefail
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts/lib.sh"

DO_BREW=1; DO_APPS=1; DO_MACOS=0; DO_VSCODE=1
for a in "$@"; do
  case "$a" in
    --dry-run)   DRY_RUN=1 ;;
    --no-brew)   DO_BREW=0 ;;
    --no-apps)   DO_APPS=0 ;;
    --no-vscode) DO_VSCODE=0 ;;
    --macos)     DO_MACOS=1 ;;
    -h|--help)   sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown flag: $a (see --help)" ;;
  esac
done
export DRY_RUN

# -- 1. Homebrew --------------------------------------------------------------
if [ "$DO_BREW" = 1 ] && is_mac; then
  step "Homebrew"
  if ! load_brew; then
    info "brew not found - installing it (official installer)"
    run /bin/bash -c 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    [ "$DRY_RUN" = 1 ] || load_brew || die "brew was installed but is not on PATH"
  else
    ok "brew $(brew --prefix)"
  fi
  export HOMEBREW_NO_ANALYTICS=1

  step "Brewfile (latest versions, nothing pinned)"
  # recent brew versions require third-party taps to be trusted explicitly - only the taps in the Brewfile
  for tap in $(sed -n 's/^tap "\([^"]*\)".*/\1/p' "$DOTFILES/Brewfile"); do
    run brew tap "$tap" 2>/dev/null || true
    run brew trust "$tap" 2>/dev/null || true
  done
  run brew bundle --file="$DOTFILES/Brewfile" || warn "some Brewfile packages failed - retry with: brew bundle --file=Brewfile"

  if [ "$DO_APPS" = 1 ]; then
    step "Brewfile.apps (GUI)"
    run brew bundle --file="$DOTFILES/Brewfile.apps" || warn "some apps failed (mas needs an App Store sign-in)"
  fi
elif ! is_mac; then
  warn "not macOS - skipping brew, apps and macos defaults"
fi

# -- 2. oh-my-zsh, plugins, p10k, tpm -----------------------------------------
"$DOTFILES/scripts/shell.sh"

# -- 2b. Fonts that are not in brew -------------------------------------------
# "Fira Code Freeze" (kitty and VS Code) is a custom variant that lives in the repository.
if is_mac && [ -d "$DOTFILES/fonts" ]; then
  step "Fonts from the repository"
  run mkdir -p "$HOME/Library/Fonts"
  for f in "$DOTFILES"/fonts/*.ttf; do
    [ -e "$f" ] || continue
    if cmp -s "$f" "$HOME/Library/Fonts/$(basename "$f")"; then info "already present: $(basename "$f")"
    else run cp -f "$f" "$HOME/Library/Fonts/" && ok "$(basename "$f")"; fi
  done
fi

# -- 3. Symlinks --------------------------------------------------------------
"$DOTFILES/scripts/link.sh"

# -- 4. Local (private, per-machine) files ------------------------------------
step "Local files (not in the repository)"
if [ ! -e "$HOME/.gitconfig.local" ]; then
  if [ "$DRY_RUN" != 1 ]; then
    {
      echo "# Git settings for this machine only. Included from ~/.dotfiles/gitconfig."
      if is_mac; then printf '[credential]\n\thelper = osxkeychain\n'; fi
    } > "$HOME/.gitconfig.local"
  fi
  ok "created ~/.gitconfig.local"
else
  info "~/.gitconfig.local already exists"
fi
if [ ! -e "$HOME/.zshrc.local" ]; then
  [ "$DRY_RUN" = 1 ] || printf '# Secrets and settings for this machine only (not tracked in git).\n# export BITBUCKET_LOGIN=...\n' > "$HOME/.zshrc.local"
  ok "created ~/.zshrc.local"
else
  info "~/.zshrc.local already exists"
fi

# -- 5. VS Code ---------------------------------------------------------------
if [ "$DO_VSCODE" = 1 ] && have code && [ -f "$DOTFILES/vscode/extensions.txt" ]; then
  step "VS Code extensions"
  have_ext=$(code --list-extensions 2>/dev/null | tr 'A-Z' 'a-z' || true)
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    echo "$have_ext" | grep -qx "$(echo "$ext" | tr 'A-Z' 'a-z')" || run code --install-extension "$ext" --force >/dev/null
  done < "$DOTFILES/vscode/extensions.txt"
  ok "extensions are in place"
fi

# -- 6. Neovim: plugins pinned by lazy-lock.json ------------------------------
if have nvim; then
  step "Neovim plugins (from lazy-lock.json)"
  run nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1 || warn "nvim plugins: open nvim and run :Lazy restore"
fi

# -- 7. macOS defaults (opt-in) -----------------------------------------------
if [ "$DO_MACOS" = 1 ] && is_mac; then "$DOTFILES/scripts/macos.sh"; fi

step "Done"
cat <<'MSG'
  Manual steps (no secrets are stored in this repository):
   * restart the terminal (or: exec zsh) so p10k picks up ~/.p10k.zsh
   * gh auth login; glab auth login
   * SSH and GPG keys: restore from your password manager / backup (~/.ssh, gpg --import)
   * Ruby: install rvm (https://rvm.io), then: rvm install <version>
   * Node: nvm install --lts   (nvm is lazy-loaded: the first call is a bit slower)
   * Karabiner-Elements / Docker Desktop: first launch, grant permissions in System Settings
   * Check everything with: scripts/doctor.sh
MSG
