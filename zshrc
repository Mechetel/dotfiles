# ~/.zshrc  ->  ~/.dotfiles/zshrc   (симлинк, см. scripts/link.sh)
#
# Порядок важен:
#   1. p10k instant prompt   — самым первым
#   2. brew + PATH           — до oh-my-zsh, чтобы плагины видели нужные бинарники
#   3. oh-my-zsh + плагины
#   4. zsh/*.sh (алиасы, функции, биндинги)
#   5. менеджеры версий      — rvm ПОСЛЕДНИМ из тех, что трогают PATH
#   6. p10k.zsh
# Машинно-специфичное и секреты — в ~/.zshrc.local (в git не попадает).

export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

typeset -U path PATH fpath    # без дублей в PATH и fpath

# Корень репозитория определяется по симлинку, а не хардкодится.
export DOTFILES="${${(%):-%N}:A:h}"

# ── 1. Powerlevel10k instant prompt ──────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── 2. Homebrew и PATH ───────────────────────────────────────────────────────
# Apple Silicon -> /opt/homebrew, Intel -> /usr/local.
for _b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $_b ]] && { eval "$($_b shellenv)"; break; }
done
unset _b
export HOMEBREW_NO_ANALYTICS=1

# Добавляет существующие каталоги: _path_front — в начало, _path_back — в конец.
_path_front() { local d; for d in "${(Oa)@}"; do [[ -d $d ]] && path=($d ${path:#$d}); done; }
_path_back()  { local d; for d in "$@";        do [[ -d $d ]] && path=(${path:#$d} $d); done; }

# keg-only формулы brew (в порядке приоритета). Версионные kegs (node@20, mysql@5.7) сюда
# больше не нужны: ставится последняя версия, она уже в $HOMEBREW_PREFIX/bin.
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

# ── 3. oh-my-zsh ─────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER="$USER"

# Не ходить в сеть при старте и не гонять compaudit (каждый запуск стоил ~100 мс).
zstyle ':omz:update' mode disabled
ZSH_DISABLE_COMPFIX=true

plugins=(
  git
  ## внешний вид
  colorize
  compleat
  common-aliases
  ## редактирование и навигация
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
  ## внешние (ставит scripts/shell.sh); syntax-highlighting — строго последним
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

PROJECT_PATHS=($HOME/Projects)   # плагин pj

source "$ZSH/oh-my-zsh.sh"

# История: больше и без дублей (oh-my-zsh по умолчанию хранит всего 10 000).
HISTSIZE=200000
SAVEHIST=200000
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE SHARE_HISTORY

# ── 4. Алиасы, функции, биндинги ─────────────────────────────────────────────
for _f in "$DOTFILES"/zsh/*.sh(N); do source "$_f"; done
unset _f

# fzf: Ctrl-R (история), Ctrl-T (файлы), Alt-C (cd). После oh-my-zsh, чтобы перебить vi-mode.
(( $+commands[fzf] )) && source <(fzf --zsh 2>/dev/null)

# ── 5. Менеджеры версий ──────────────────────────────────────────────────────
# nvm — лениво: nvm.sh стоил ~600 мс на каждый запуск шелла. Первый вызов `nvm`
# подгружает его и сразу выполняет команду; node/npm берутся из brew.
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm
  local _nvm_sh="${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/nvm/nvm.sh}"
  [[ -s $_nvm_sh ]] || _nvm_sh="$NVM_DIR/nvm.sh"
  [[ -s $_nvm_sh ]] && source "$_nvm_sh" || { print -u2 "nvm не установлен (brew install nvm)"; return 1 }
  nvm "$@"
}

# VS Code shell integration
if [[ $TERM_PROGRAM == vscode ]] && (( $+commands[code] )); then
  source "$(code --locate-shell-integration-path zsh)"
fi

# Локальное для этой машины (секреты, рабочие токены, пути)
[[ -f $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"

# rvm — последним: он требует быть последним в PATH.
_path_back "$HOME/.rvm/bin"
[[ -s $HOME/.rvm/scripts/rvm ]] && source "$HOME/.rvm/scripts/rvm"
# brew shellenv ставит /usr/local/bin в начало, и rvm оказывается за ним — тогда `bundle`/`gem`
# берутся из системы. Явно вернуть bin текущего ruby/gemset на первое место.
if [[ -n $GEM_HOME && -n $MY_RUBY_HOME ]]; then
  _path_front "$GEM_HOME/bin" "$GEM_HOME@global/bin" "$MY_RUBY_HOME/bin"
fi
# Новые панели/окна tmux: дёрнуть rvm-хук cd, чтобы подхватить .ruby-version
if [[ -n $TMUX ]] && (( $+functions[rvm] )); then
  cd "$PWD"
fi

# ── 6. Тема ──────────────────────────────────────────────────────────────────
# Настройка промпта: `p10k configure` или правка ~/.dotfiles/p10k.zsh
[[ -f $HOME/.p10k.zsh ]] && source "$HOME/.p10k.zsh"
# Запасной вариант без p10k: eval "$(starship init zsh)"
