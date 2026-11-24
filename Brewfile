# CLI-инструменты, рантаймы и шрифты. Версии НЕ закреплены: на новом компьютере
# ставятся последние (никаких mysql@5.7 / python@3.10 / node@20).
#
#   brew bundle --file=~/.dotfiles/Brewfile        # поставить всё
#   brew bundle check --file=~/.dotfiles/Brewfile  # чего не хватает
#   scripts/snapshot.sh                            # что стоит в системе, но не записано здесь
#
# Транзитивные зависимости (libheif, nettle, harfbuzz …) сюда не вносятся —
# brew подтянет их сам.

# ── Taps ─────────────────────────────────────────────────────────────────────
# Сторонние tap-ы в новом brew надо «доверять» явно — install.sh делает
# `brew trust` для тапов ниже; вручную: brew trust heroku/brew stripe/stripe-cli
tap "heroku/brew"
tap "stripe/stripe-cli"

# ── Оболочка и терминал ──────────────────────────────────────────────────────
brew "zsh"
brew "tmux"
brew "starship"          # запасной промпт (основной — powerlevel10k)
brew "fzf"
brew "ripgrep"
brew "fd"
brew "the_silver_searcher"
brew "tree"
brew "htop"
brew "fastfetch"          # замена neofetch (тот заархивирован и убран из brew)
brew "ranger"
brew "highlight"         # подсветка в превью ranger
brew "jq"
brew "wget"
brew "coreutils"
brew "telnet"
brew "rclone"
brew "mkcert"

# ── Git ──────────────────────────────────────────────────────────────────────
brew "git"
brew "git-lfs"           # в gitconfig прописан lfs-фильтр
brew "git-flow"
brew "git-crypt"
brew "gh"
brew "glab"
brew "diff-so-fancy"     # core.pager в gitconfig
brew "gitlab-runner"
brew "gnupg"
brew "pinentry-mac"

# ── Редактор ─────────────────────────────────────────────────────────────────
brew "neovim"
brew "tree-sitter-cli"
brew "luarocks"
brew "rust-analyzer"

# ── Языки и рантаймы ─────────────────────────────────────────────────────────
brew "node"
brew "nvm"
brew "yarn"
brew "python"
brew "rust"
brew "ruby-build"        # ruby ставится через rvm (см. README), это для rbenv-совместимости
brew "asdf"
# нативные зависимости гемов (rails: nokogiri, psych, pg, mysql2 …)
brew "openssl@3"
brew "libyaml"
brew "libxslt"
brew "icu4c"
brew "libpq"
brew "readline"

# ── Базы данных и сервисы ────────────────────────────────────────────────────
brew "mysql"
brew "postgresql@18"
brew "pgloader"
brew "redis"
brew "meilisearch"
brew "kafka"

# ── Медиа ────────────────────────────────────────────────────────────────────
brew "ffmpeg"
brew "imagemagick"
brew "vips"
brew "graphviz"
brew "ghostscript"
brew "tesseract"

# ── Прочее ───────────────────────────────────────────────────────────────────
brew "exercism"
brew "mpich"
brew "mas"               # Mac App Store из командной строки (см. Brewfile.apps)
brew "heroku/brew/heroku"
brew "stripe/stripe-cli/stripe"

# ── Шрифты (kitty/vscode/p10k) ───────────────────────────────────────────────
cask "font-fira-code"
cask "font-hack-nerd-font"
cask "font-meslo-lg-nerd-font"   # MesloLGS NF — шрифт терминала vscode / p10k

# ── Хочется попробовать (раскомментируй) ─────────────────────────────────────
# brew "bat"        # cat с подсветкой
# brew "eza"        # современный ls
# brew "zoxide"     # умный cd
# brew "git-delta"  # красивый git diff (замена diff-so-fancy)
# brew "lazygit"
# brew "mise"       # один менеджер вместо nvm + rvm + asdf
