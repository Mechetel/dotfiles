export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

typeset -U PATH

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH="$PATH:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"

#add python3 from brew
export PATH="/usr/local/opt/python@3.11/libexec/bin:$PATH"

# Add node modules
export PATH="$PATH:$HOME/.node_modules/bin"

# this is for haskell
export PATH="$PATH:$HOME/.local/bin"
[ -f "/Users/dmitryhoma/.ghcup/env" ] && . "/Users/dmitryhoma/.ghcup/env" # ghcup-env

# apps important paths
export PATH="$PATH:/Library/Apple/usr/bin"
export PATH="$PATH:/System/Cryptexes/App/usr/bin"

# postgres
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"
export PATH="$PATH:/usr/local/opt/postgresql@17/bin"

# OpenJDK for elasticsearch # deprecated
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# elasticsearch and kibana
export PATH="$PATH:$HOME/.elasticsearch/bin"
export PATH="$PATH:$HOME/.kibana/bin"

# Path to your oh-my-zsh installation.
export ZSH="/Users/dmitryhoma/.oh-my-zsh"
export EDITOR="/usr/local/bin/nvim"
export VISUAL="/usr/local/bin/nvim"

ZSH_THEME="powerlevel10k/powerlevel10k"

DEFAULT_USER="$USER"

plugins=(
  git
  ## appearence
  colorize
  compleat
  common-aliases
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions

  ## editing
  vi-mode

  ## navigation
  dirpersist
  pj
  zsh-navigation-tools

  systemd
  sudo

  ## ruby
  bundler
  ruby
  rails
  gem

  ## docker
  docker
  docker-compose
)

source $ZSH/oh-my-zsh.sh

DOTFILES=$HOME/.dotfiles

for file in $HOME/.dotfiles/zsh/*.sh; do
  source $file
done

PROJECT_PATHS=($HOME/Projects)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/dmitryhoma/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/dmitryhoma/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/dmitryhoma/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/dmitryhoma/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# ruby which is instelled by brew <<<<< on the SECOND PATH
export PATH="/usr/local/opt/node@20/bin:$PATH"
# export PATH="/usr/local/opt/node@14/bin:$PATH"
export PATH="/Users/dmitryhoma/.nvm/versions/node/v16.20.0/bin/node:$PATH"

export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"

export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="/usr/local/opt/openssl@3/bin:$PATH"

export PKG_CONFIG_PATH="/usr/local/opt/libxslt/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig:$PKG_CONFIG_PATH"

# =================== RUBY RVM =======================
# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

# Enable auto-switching of Ruby versions when changing directories
export rvm_project_rvmrc=1

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# For tmux sessions, ensure RVM is properly loaded
if [[ -n $TMUX ]] && [[ "$(whence -w rvm)" == *"function"* ]]; then
    rvm use default >/dev/null 2>&1 6>&1
    cd .
fi

source ~/.powerlevel10k/powerlevel10k.zsh-theme

# VS Code Shell Integration - Official method
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    # Load official VS Code script
    source "$(code --locate-shell-integration-path zsh)"

    # Force required environment variables
    export VSCODE_SHELL_INTEGRATION=1
    export VSCODE_INJECTION=1
fi

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/p10k.zsh.
[[ ! -f ~/.dotfiles/p10k.zsh ]] || source ~/.dotfiles/p10k.zsh

# eval "$(starship init zsh)"
