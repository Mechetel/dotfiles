DOTFILES=$HOME/.dotfiles

for file in $HOME/.dotfiles/zsh/*.sh; do
  source $file
done

PROJECT_PATHS=($HOME/projects)
