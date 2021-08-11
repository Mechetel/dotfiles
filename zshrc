# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.node_modules/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# Path to your oh-my-zsh installation.

# ZSH=$HOME/.oh-my-zsh

export ZSH="/Users/dmitryhoma/.oh-my-zsh"

export EDITOR=/usr/local/bin/nvim
export VISUAL=/usr/local/bin/nvim

ZSH_THEME="agnoster"

DEFAULT_USER="$USER"


plugins=(
  git
  ## appearence
  colorize
  compleat
  common-aliases
  zsh-autosuggestions
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

PROJECT_PATHS=($HOME/projects)

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
