DOTFILES=$HOME/.dotfiles

source $HOME/projects/zsh-nordicres/index.sh

for file in $HOME/.dotfiles/zsh/*.sh; do
  source $file
done

PROJECT_PATHS=($HOME/projects)
