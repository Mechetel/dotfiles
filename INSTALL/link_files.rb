#! /usr/bin/env ruby

require_relative './config'

inhome_indotfiles = [
  ['.zshrc',                                               'zshrc'],
  ['.p10k.zsh',                                            'p10k.zsh'],
  ['.tmux.conf',                                           'tmux.conf'],

  ['.config/ranger/commands.py',                           'ranger/commands.py'],
  ['.config/ranger/history',                               'ranger/history'],
  ['.config/ranger/rc.conf',                               'ranger/rc.conf'],
  ['.config/ranger/scope.sh',                              'ranger/scope.sh'],

  ['.stack/config.yaml',                                   'stack-global.yaml'],
  ['.gitconfig',                                           'gitconfig'],
  ['.gitignore_global',                                    'gitignore_global'],
  ['.commitlintrc.yml',                                    'commitlintrc.yml'],

  ['.config/nvim/ftplugin',                                'nvim/ftplugin'],
  ['.config/nvim/plugin',                                  'nvim/plugin'],
  ['.config/nvim/snippets',                                'nvim/snippets'],
  ['.config/nvim/ginit.vim',                               'nvim/ginit.vim'],
  ['.config/nvim/init.vim',                                'nvim/init.vim'],
  ['.config/nvim/coc-settings.json',                       'nvim/coc-settings.json'],
  ['.config/nvim/bundle/repos/github.com/Shougo/dein.vim', 'nvim/bundle/repos/github.com/Shougo/dein.vim'],
]

inhome_indotfiles.each do |(inhome, indotfiles)|
  inhome_     = File.join $home, inhome
  indotfiles_ = File.join $dotfiles, indotfiles
  `mkdir -p "$(dirname "#{inhome_}")"`
  `sudo ln -sf "#{indotfiles_}" "#{inhome_}"`
end
