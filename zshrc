# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# If you come from bash you might have to change your $PATH.
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"

#add python3 from brew
export PATH="/usr/local/opt/python@3.10/libexec/bin:$PATH"

# Add node modules
export PATH="$PATH:$HOME/.node_modules/bin"

# this is for haskell
export PATH="$PATH:$HOME/.local/bin"

# apps important paths
export PATH="$PATH:/Library/Apple/usr/bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"

# Add anaconda to path before python@3.10
# export PATH="/opt/anaconda3/bin:$PATH"
# export PATH="/opt/anaconda3/condabin:$PATH"

# Add anaconda to path after python@3.10
export PATH="$PATH:/opt/anaconda3/bin"
export PATH="$PATH:/opt/anaconda3/condabin"

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# ruby which is instelled by brew <<<<< on the SECOND PATH
export PATH="/usr/local/opt/ruby/bin:$PATH"

# =================== RUBY RVM =======================
export PATH="$MY_RUBY_HOME/bin:$PATH"
export PATH="$GEM_PATH/bin:$PATH"
export PATH="$GEM_HOME/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/p10k.zsh.
[[ ! -f ~/.dotfiles/p10k.zsh ]] || source ~/.dotfiles/p10k.zsh
