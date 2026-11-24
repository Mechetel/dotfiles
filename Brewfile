# CLI tools, runtimes and fonts. Versions are NOT pinned: a new computer gets the latest
# of everything (no mysql@5.7 / python@3.10 / node@20).
#
#   brew bundle --file=~/.dotfiles/Brewfile        # install everything
#   brew bundle check --file=~/.dotfiles/Brewfile  # what is missing
#   scripts/snapshot.sh                            # installed here but not recorded below
#
# Transitive dependencies (libheif, nettle, harfbuzz ...) are intentionally not listed:
# brew pulls them in by itself.

# -- Taps ----------------------------------------------------------------------
# Recent brew versions require third-party taps to be trusted explicitly. install.sh runs
# `brew trust` for the taps below; by hand: brew trust heroku/brew stripe/stripe-cli
tap "heroku/brew"
tap "stripe/stripe-cli"

# -- Shell and terminal --------------------------------------------------------
brew "zsh"
brew "tmux"
brew "starship"          # fallback prompt (powerlevel10k is the main one)
brew "fzf"
brew "ripgrep"
brew "fd"
brew "the_silver_searcher"
brew "tree"
brew "htop"
brew "fastfetch"         # replacement for neofetch (archived and removed from brew)
brew "ranger"
brew "highlight"         # syntax highlighting in ranger previews
brew "jq"
brew "wget"
brew "coreutils"
brew "telnet"
brew "rclone"
brew "mkcert"

# -- Git -----------------------------------------------------------------------
brew "git"
brew "git-lfs"           # gitconfig defines the lfs filter
brew "git-flow"
brew "git-crypt"
brew "gh"
brew "glab"
brew "diff-so-fancy"     # core.pager in gitconfig
brew "gitlab-runner"
brew "gnupg"
brew "pinentry-mac"

# -- Editor --------------------------------------------------------------------
brew "neovim"
brew "tree-sitter-cli"
brew "luarocks"
brew "rust-analyzer"

# -- Languages and runtimes ----------------------------------------------------
brew "node"
brew "nvm"
brew "yarn"
brew "python"
brew "rust"
brew "ruby-build"        # ruby itself comes from rvm (see README); this is for rbenv compatibility
brew "asdf"
# native dependencies of gems (rails: nokogiri, psych, pg, mysql2 ...)
brew "openssl@3"
brew "libyaml"
brew "libxslt"
brew "icu4c"
brew "libpq"
brew "readline"

# -- Databases and services ----------------------------------------------------
brew "mysql"
brew "postgresql@18"
brew "pgloader"
brew "redis"
brew "meilisearch"
brew "kafka"

# -- Media ---------------------------------------------------------------------
brew "ffmpeg"
brew "imagemagick"
brew "vips"
brew "graphviz"
brew "ghostscript"
brew "tesseract"

# -- Misc ----------------------------------------------------------------------
brew "exercism"
brew "mpich"
brew "mas"               # Mac App Store from the command line (see Brewfile.apps)
brew "heroku/brew/heroku"
brew "stripe/stripe-cli/stripe"

# -- Fonts (kitty / vscode / p10k) ---------------------------------------------
cask "font-fira-code"
cask "font-hack-nerd-font"
cask "font-meslo-lg-nerd-font"   # MesloLGS NF - the vscode terminal / p10k font

# -- Worth trying (uncomment) --------------------------------------------------
# brew "bat"        # cat with syntax highlighting
# brew "eza"        # modern ls
# brew "zoxide"     # smarter cd
# brew "git-delta"  # prettier git diff (replaces diff-so-fancy)
# brew "lazygit"
# brew "mise"       # one version manager instead of nvm + rvm + asdf
