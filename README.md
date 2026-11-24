# dotfiles

Конфиги macOS-окружения: zsh (oh-my-zsh + powerlevel10k), tmux, neovim, kitty, git, ranger,
Karabiner, VS Code. Всё ставится одной командой, **всегда последние версии** (в `Brewfile`
версии не закреплены).

## Установка на новом Mac

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Mechetel/dotfiles/master/bootstrap.sh)"
```

Скрипт поставит Xcode Command Line Tools, клонирует репозиторий в `~/.dotfiles` и запустит
`install.sh`. То же вручную:

```bash
git clone https://github.com/Mechetel/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

Флаги `install.sh` (можно передавать и в `bootstrap.sh`):

| Флаг | Что делает |
|---|---|
| `--dry-run` | показать шаги, ничего не меняя |
| `--no-apps` | без GUI-приложений (`Brewfile.apps`) |
| `--no-brew` | без brew вообще — только линки и шелл |
| `--no-vscode` | не ставить расширения VS Code |
| `--macos` | применить системные настройки (`scripts/macos.sh`) |

Установщик идемпотентен — безопасно запускать повторно после `git pull`.
Существующие файлы **не затираются**: они переезжают в `~/.dotfiles-backup/<дата>/`.

### Что происходит по шагам

1. **Homebrew** (если нет) → `Brewfile` (CLI, рантаймы, шрифты) → `Brewfile.apps` (GUI, Mac App Store)
2. **oh-my-zsh**, плагины (autosuggestions, syntax-highlighting, completions), **powerlevel10k**, **tpm** — `scripts/shell.sh`
3. Шрифт «Fira Code Freeze» из `fonts/` → `~/Library/Fonts`
4. **Симлинки** в `$HOME` — `scripts/link.sh`
5. Локальные файлы `~/.gitconfig.local`, `~/.zshrc.local` (в git не попадают)
6. Расширения VS Code (`vscode/extensions.txt`), плагины neovim (строго по `nvim/lazy-lock.json`), глобальные npm-пакеты (`packages/npm.txt`)

### Что остаётся руками

Секреты в репозиторий **не** кладутся — он публичный.

- `gh auth login`, `glab auth login`
- SSH- и GPG-ключи — из менеджера паролей / бэкапа (`gpg-backup` / `gpg-restore` работают с `~/.local/share/gpg-backup`, не с репозиторием)
- Ruby: [rvm](https://rvm.io), затем `rvm install <версия>`
- Node: `nvm install --lts` (nvm подгружается лениво)
- Karabiner-Elements, Docker Desktop — первый запуск и разрешения в Системных настройках
- Приложения вне brew: Adobe CC, Microsoft Office, Mathematica, ClearVPN, Folx и др.

## Структура

```
bootstrap.sh          # curl-точка входа: CLT + clone + install.sh
install.sh            # оркестратор
Brewfile              # CLI, рантаймы, шрифты (без версий)
Brewfile.apps         # GUI-приложения и Mac App Store
scripts/
  link.sh             # симлинки с бэкапом (+ --dry-run); список файлов — массив LINKS
  shell.sh            # oh-my-zsh, плагины, p10k, tpm
  macos.sh            # defaults write (по флагу --macos)
  snapshot.sh         # что стоит, но не записано в Brewfile; --vscode обновляет расширения
  doctor.sh           # проверка ссылок, инструментов, секретов, скорости zsh
zshrc  zsh/*.sh       # конфиг zsh; алиасы/функции/биндинги по темам
p10k.zsh starship.toml
gitconfig gitignore_global commitlintrc.yml
tmux.conf tmux/       # + тема dracula, биндинги
nvim/                 # lazy.nvim, lazy-lock.json закрепляет версии плагинов
kitty/ karabiner/ ranger/ vscode/ fonts/ packages/
archive/              # старое (nvim-old, zsh-trash) — не используется
```

## Как пользоваться

```bash
scripts/doctor.sh       # всё ли на месте, нет ли секретов, как быстро стартует zsh
scripts/snapshot.sh     # что поставил на этом Mac, но забыл записать
scripts/link.sh --dry-run
```

**Добавить новый конфиг** — положить файл в репозиторий и добавить строку в массив `LINKS`
в `scripts/link.sh`: `"путь-в-репо|путь-от-$HOME"`.

**Поставил новую программу** — допиши её в `Brewfile`/`Brewfile.apps` (`scripts/snapshot.sh`
подскажет, чего не хватает) и закоммить.

**Настройки только для этого компьютера** (токены, закреплённые версии) — `~/.zshrc.local`
и `~/.gitconfig.local`. Они не в git. Пример: на старом Mac там лежит
`path=(/usr/local/opt/node@20/bin /usr/local/opt/mysql@5.7/bin $path)`.

## Заметки

- Работает и на Intel (`/usr/local`), и на Apple Silicon (`/opt/homebrew`): префикс brew
  определяется автоматически, в путях нет `/Users/<имя>`.
- Старт zsh ~0,5 с (было ~1,8 с): `nvm` грузится лениво, обновления oh-my-zsh отключены.
- Репозиторий публичный: `.gitignore` закрывает `secrets/`, `*.local`, ключи и токены, а
  `scripts/doctor.sh` ищет похожее на секреты в отслеживаемых файлах.
