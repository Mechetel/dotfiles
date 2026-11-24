# ~/.zshrc  ->  ~/.dotfiles/zshrc   (symlink, see scripts/link.sh)
#
# Order matters:
#   1. p10k instant prompt   - must come first
#   2. brew + PATH           - before oh-my-zsh so plugins can see the binaries
#   3. oh-my-zsh + plugins
#   4. zsh/*.sh (aliases, functions, key bindings)
#   5. version managers      - rvm LAST, it must be the last thing to touch PATH
#   6. p10k.zsh
# Machine-specific settings and secrets go to ~/.zshrc.local (not tracked in git).

export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

typeset -U path PATH fpath    # no duplicates in PATH and fpath

# The repository root is resolved through the symlink instead of being hardcoded.
export DOTFILES="${${(%):-%N}:A:h}"

# -- 1. Powerlevel10k instant prompt -------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- 2. Homebrew and PATH ------------------------------------------------------
# Apple Silicon -> /opt/homebrew, Intel -> /usr/local.
for _b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $_b ]] && { eval "$($_b shellenv)"; break; }
done
unset _b
export HOMEBREW_NO_ANALYTICS=1

# Add existing directories only: _path_front prepends (keeping the given order), _path_back appends.
_path_front() { local d; for d in "${(Oa)@}"; do [[ -d $d ]] && path=($d ${path:#$d}); done; }
_path_back()  { local d; for d in "$@";        do [[ -d $d ]] && path=(${path:#$d} $d); done; }

# keg-only brew formulae (in priority order). Versioned kegs (node@20, mysql@5.7) are no
# longer needed here: the latest version is installed and already lives in $HOMEBREW_PREFIX/bin.
if [[ -n $HOMEBREW_PREFIX ]]; then
  _kegs=()
  for _k in openssl@3 icu4c; do
    _kegs+=("$HOMEBREW_PREFIX/opt/$_k/bin" "$HOMEBREW_PREFIX/opt/$_k/sbin")
  done
  _path_front $_kegs
  unset _kegs _k

  export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/libxslt/lib/pkgconfig:$HOMEBREW_PREFIX/opt/libxml2/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
fi

_path_back \
  "$DOTFILES/bin" \
  "$HOME/.local/bin" \
  "$HOME/.bun/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.node_modules/bin" \
  "$HOME/.elan/bin" \
  "/Applications/Postgres.app/Contents/Versions/latest/bin" \
  "${HOMEBREW_PREFIX:-/usr/local}/opt/postgresql@18/bin" \
  "${HOMEBREW_PREFIX:-/usr/local}/opt/libpq/bin" \
  "$HOME/.elasticsearch/bin" \
  "$HOME/.kibana/bin" \
  "$HOME/.meilisearch/bin"

[[ -f $HOME/.ghcup/env ]] && source "$HOME/.ghcup/env"

export EDITOR=nvim
export VISUAL=nvim
export FI_PROVIDER=tcp

# -- 3. oh-my-zsh --------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER="$USER"

# No network access at startup and no compaudit (together they cost ~100 ms per start).
zstyle ':omz:update' mode disabled
ZSH_DISABLE_COMPFIX=true

plugins=(
  git
  ## appearance
  colorize
  compleat
  common-aliases
  ## editing and navigation
  vi-mode
  dirpersist
  pj
  zsh-navigation-tools
  sudo
  ## ruby
  bundler
  ruby
  rails
  gem
  ## docker
  docker
  docker-compose
  ## external (installed by scripts/shell.sh); syntax-highlighting must stay last
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

PROJECT_PATHS=($HOME/Projects)   # used by the pj plugin

source "$ZSH/oh-my-zsh.sh"

# History: bigger and without duplicates (the oh-my-zsh default keeps only 10,000 entries).
HISTSIZE=200000
SAVEHIST=200000
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE SHARE_HISTORY

# -- 4. Aliases, functions, key bindings ---------------------------------------
for _f in "$DOTFILES"/zsh/*.sh(N); do source "$_f"; done
unset _f

# fzf: Ctrl-R (history), Ctrl-T (files), Alt-C (cd). After oh-my-zsh so it overrides vi-mode.
(( $+commands[fzf] )) && source <(fzf --zsh 2>/dev/null)

# -- 5. Version managers -------------------------------------------------------
# nvm is lazy: sourcing nvm.sh cost ~600 ms on every shell start. The first `nvm` call
# loads it and runs the command; node/npm come from brew.
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm
  local _nvm_sh="${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/nvm/nvm.sh}"
  [[ -s $_nvm_sh ]] || _nvm_sh="$NVM_DIR/nvm.sh"
  [[ -s $_nvm_sh ]] && source "$_nvm_sh" || { print -u2 "nvm is not installed (brew install nvm)"; return 1 }
  nvm "$@"
}

# VS Code shell integration
if [[ $TERM_PROGRAM == vscode ]] && (( $+commands[code] )); then
  source "$(code --locate-shell-integration-path zsh)"
fi

# Machine-specific settings (secrets, work tokens, paths)
[[ -f $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"

# rvm goes last: it insists on being the last thing that changes PATH.
_path_back "$HOME/.rvm/bin"
[[ -s $HOME/.rvm/scripts/rvm ]] && source "$HOME/.rvm/scripts/rvm"
# brew shellenv puts /usr/local/bin first, which leaves rvm behind it - then `bundle`/`gem`
# resolve to the system copies. Move the bin dirs of the current ruby/gemset back to the front.
if [[ -n $GEM_HOME && -n $MY_RUBY_HOME ]]; then
  _path_front "$GEM_HOME/bin" "$GEM_HOME@global/bin" "$MY_RUBY_HOME/bin"
fi
# New tmux panes/windows: trigger rvm's cd hook so .ruby-version is picked up
if [[ -n $TMUX ]] && (( $+functions[rvm] )); then
  cd "$PWD"
fi

# -- 6. Theme ------------------------------------------------------------------
# Prompt settings: run `p10k configure` or edit ~/.dotfiles/p10k.zsh
[[ -f $HOME/.p10k.zsh ]] && source "$HOME/.p10k.zsh"
# Fallback without p10k: eval "$(starship init zsh)"
